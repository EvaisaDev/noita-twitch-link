require('dotenv').config();
const setTitle = require('console-title');
const winston = require('winston');
const ws = require('ws');
const tmi = require('tmi.js');
const fs = require('fs');
const rq = require('request-promise');

let CHANNEL =  null;

const WS_PORT = 53225;
let SECS_BETWEEN_VOTES = 0;
let random_vote_seconds = 10;
let SECS_FOR_VOTE = 10;
let lastContact = Date.now();
let skip_vote = false;
let delay = 0;
let vote_count = 3;

let timeleft = 0;
let user_votes = {};
let usernames = {};

try {
  fs.unlinkSync("./twitch-link.log")
  //file removed
} catch(err) {
  console.error(err)
}

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp({
      format: 'YYYY-MM-DD HH:mm:ss'
    }),
    winston.format.errors({ stack: true }),
    winston.format.splat(),
    winston.format.json()
  ),  
  defaultMeta: { service: 'twitch-link' },
  transports: [
    //
    // - Write all logs with level `error` and below to `error.log`
    // - Write all logs with level `info` and below to `combined.log`
    //
    new winston.transports.File({ filename: 'twitch-link.log' })
  ]
});

const wss = new ws.Server({ port: WS_PORT });
console.log("WS listening on " + WS_PORT);
logger.log('info', "WS listening on " + WS_PORT);

let noita = null;
let noita2 = null;

function getConnectionName(ws) {
  return ws._socket.remoteAddress + ":" + ws._socket.remotePort;
}

function noitaDoFile(fn) {
  if (noita == null) {
    return;
  }
  const fdata = fs.readFileSync(fn);
  noita.send(fdata);
}


function noitaDoFolder(fn){

	fs.readdir(fn, function (err, files) {
		//handling error
		if (err) {
			logger.log('error', 'Unable to scan directory: ' + err);
			return console.log('Unable to scan directory: ' + err);
		} 
		//listing all files using forEach
		files.forEach(function (file) {
			// Do whatever you want to do with the file
			if (noita == null) {
				return;
			}
			const fdata = fs.readFileSync(fn+file);
			noita.send(fdata);
		});
	});
}

const getChatters = (channelName, _attemptCount = 0) => {
	return rq({
		uri: `https://tmi.twitch.tv/group/user/${channelName}/chatters`,
		json: true
	})
		.then((data) => {
			return Object.entries(data.chatters).reduce(
				(p, [ type, list ]) =>
					p.concat(
						list.map((name) => {
							// if (name === channelName) type = 'broadcaster';
							// return { name, type };
							return name;
						})
					),
				[]			// <= reduce's initial value
			);
		})
		.catch((err) => {
			if (_attemptCount < 3) {
				console.log("i'll try again!");
				return getChatters(channelName, _attemptCount + 1);
			}
			console.log('tried 3 times and failed');
			throw err;
		});
};

const getRandomChatter = (channelName, opts = {}) => {
	let { onlyViewers = false, noBroadcaster = false, skipList = [] } = opts;
	return getChatters(channelName).then((data) => {
		let chatters = data.filter(
			({ name, type }) =>
				!(
					(onlyViewers && type !== 'viewers') ||
					(noBroadcaster && type === 'broadcaster') ||
					skipList.includes(name)
				)
		);
		return chatters.length === 0 ? null : chatters[Math.floor(Math.random() * chatters.length)];
	});
};


const viewersInChannel = (channel) => {
	return getChatters(channel)
		.then((res) => {
			return res;
		})
		.catch((e) => {
			console.log(e)
		})
};

// TODO: refactor all this into a common file
wss.on('connection', function connection(ws) {
  const cname = getConnectionName(ws);
  console.log("New connection: " + cname);
  logger.log('info', "New connection: " + cname);
  ws.on('message', function incoming(data, flags) {
    let jdata = null;
    // special case: if the string we get is prefixed with ">",  
    // don't try to interpret as JSON, just treat it as a print
    if (data.slice(0, 1) == ">") {
	  if(data == ">RES> [no value]"){
		return
	  }
      console.log(data);
	  logger.log('info', data);
      return;
    } else {
      try {
        jdata = JSON.parse(data);
      } catch (e) {
        console.log(data);
		logger.log('info', data);
		logger.log('error', e);
        console.error(e);
        return;
      }
    }
	

	
	if(jdata["kind"] === "voteskip"){
		noita2 = null;

		SECS_FOR_VOTE = jdata["votetime"]
		random_vote_seconds = jdata["random_vote_time"]		
		vote_count = jdata["perk_count"]
		timeleft = 0;
		//skip_vote = false;
		noita.send("clear_display_remove_flag()");	
		noitaDoFile("mods/twitch_link/twitch_fragments/clear_events.lua");
		noitaDoFolder("mods/twitch_link/twitch_fragments/events/")		
	}
	if (jdata["kind"] === "perk_vote") {
		noita.send("clear_display_remove_flag()");	
		timeleft = 0;
		random_vote_seconds = 0;
		SECS_BETWEEN_VOTES = 0;
		vote_count = jdata["perk_count"]
		//skip_vote = true;
		noitaDoFile("mods/twitch_link/twitch_fragments/clear_events.lua");
		noitaDoFile("mods/twitch_link/twitch_fragments/perks.lua");			
		console.log("please work!");
	}
    if (jdata["kind"] === "heartbeat") {
	  lastContact = Date.now();
	  let noita_time = 0;
	  if(jdata["time"].split('.').join("").length < 14){
		 noita_time = Number(jdata["time"].split('.').join(""));
	  }else{
		 noita_time = Number(jdata["time"].split('.').join("").substring(0, jdata["time"].split('.').join("").length - 1)); 
	  }
	  
	  delay = lastContact - noita_time;
	  
	if(CHANNEL != null){
		viewersInChannel(CHANNEL).then(chatters => {
			for (var i = 0; i < chatters.length; i++) {
				let user = chatters[i]
				if(usernames[user] == null){
					usernames[user] = true;
					noita.send(`add_user("`+user+`")`);	
				}
			}
		}).catch(err => console.log('[ERR]', err));
	}	  
	  
	  setTitle('Noita Twitch Link - Websocket Latency: '+delay+'ms')
	  //setTitle('test')
      if (noita != ws) {
        console.log("Registering noita!");
		logger.log('info', "Registering noita!");
        noita = ws;
		CHANNEL = jdata["user"]
		SECS_FOR_VOTE = jdata["votetime"]
		random_vote_seconds = jdata["random_vote_time"]
		//SECS_BETWEEN_VOTES = 0
		chatClient.join(CHANNEL);
		vote_count = jdata["perk_count"];
        ws.send(`GamePrint('WS connected as ${cname}')`);
        ws.send("set_print_to_socket(true)");
        noitaDoFile("mods/twitch_link/twitch_fragments/setup.lua");
        noitaDoFile("mods/twitch_link/twitch_fragments/potion_material.lua");
		noitaDoFile("mods/twitch_link/twitch_fragments/select_loadout.lua");
		if(jdata["loadout_vote"] == "false"){
			noitaDoFolder("mods/twitch_link/twitch_fragments/events/");	
		}else{
			SECS_FOR_VOTE = jdata["loadout_time"];
			noitaDoFolder("mods/twitch_link/twitch_fragments/loadouts/");
		}
      }else{
		if (jdata["loadout"] == "true") {
			if(noita2 != ws){
				noita2 = ws;
				skip_vote = false;
				SECS_FOR_VOTE = jdata["votetime"];
				vote_count = jdata["perk_count"];
				noitaDoFile("mods/twitch_link/twitch_fragments/clear_events.lua");
				noitaDoFolder("mods/twitch_link/twitch_fragments/events/");
				random_vote_seconds = jdata["random_vote_time"];				
			}
		}

	  }
    }
  });

  ws.on('close', function closed(_ws, code, reason) {
    console.log("Connection closed: " + code + ", " + reason);
	logger.log('info', "Connection closed: " + code + ", " + reason);
    if (ws === noita) {
      console.log("Noita closed");
      noita = null;
	  noita2 = null;
	  process.exit(0);
    }
  });
});

function getVotes() {
  let votes = [0, 0, 0];
  for(uname in user_votes) {
    let v = user_votes[uname];
    if (v >= 1 && v <= vote_count) {
      votes[v-1] += 1;
    }
  }
  return votes;
}

let accepting_votes = false;
function handleVote(username, v) {
  if(!accepting_votes) {
    return;
  }
  let iv = parseInt(v.slice(0,1));
  if(isNaN(iv)) {
    return;
  }
  user_votes[username] = iv;
}

function sleep(nsecs) {
  return new Promise(resolve => setTimeout(resolve, nsecs * 1000));
}

async function doQuestion() {
  // main timer
  timeleft = SECS_BETWEEN_VOTES;
  while(timeleft > 0) {
    if (noita == null) {
      return;
    }
    noita.send(`set_countdown(${timeleft})`);
    timeleft -= 1;
    await sleep(1);
  }
  if (noita == null) {
    return;
  }
  accepting_votes = true;
  user_votes = {};
  noita.send("clear_display()\ndraw_outcomes("+vote_count+")");
  timeleft = SECS_FOR_VOTE;
  while(timeleft > 0) {
	if (!isPaused()) {
		if (noita == null) {
		  return;
		}
		noita.send(`set_votes{${getVotes().join(",")}}`);
		noita.send(`update_outcome_display(${timeleft})`);
		timeleft -= 1;	
	}
	if(skip_vote){
		timeleft == 0;
		skip_vote = false;
	}
	await sleep(1);
  }
  if (noita == null) {
    return;
  }
  noita.send("do_winner()");
  SECS_BETWEEN_VOTES = random_vote_seconds
}

function isPaused() {
	return Date.now() - lastContact > 3000
}

async function gameLoop() {
  while(true) {
    accepting_votes = false;
    while(noita == null) {
      console.log("Waiting for Noita...");
	  logger.log('info', "Waiting for Noita...");
      await sleep(5);
    }
    await doQuestion();
  }
}

const options = {
  options: {debug: true},
  connection: {reconnect: true}
  //identity: { username: process.env.TWITCH_USERNAME, password: process.env.TWITCH_OAUTH}
};

const chatClient = new tmi.client(options);
chatClient.connect().then((_client) => {

  chatClient.on("message", function (channel, userstate, message, self) {
    // console.log(message);
    // console.log(userstate);
    if (self) return; // Don't listen to my own messages..
    if (userstate["message-type"] === "chat") {
		/*if(noita != null){
			let user = userstate["display-name"];
			if(usernames[user] == null){
				usernames[user] = true;
				noita.send(`add_user("`+user+`")`);	
			}
		}*/
	  
      handleVote(userstate['display-name'], message);
    }
  });
});

gameLoop();
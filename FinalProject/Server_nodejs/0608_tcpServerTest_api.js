
var net = require('net');
var cron = require('node-cron');
var request = require('request');
var express = require('express');
var moment=require('moment');
var fs = require('fs');
var readline = require('readline');
var {google} = require('googleapis');
var SCOPES = ['https://www.googleapis.com/auth/calendar.readonly',
                'https://www.googleapis.com/auth/calendar'
                ];

var TOKEN_PATH = 'token.json';
var isChangeList = false;
var url = 'http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/';
var timeDataUrl = 'ForecastTimeData'; //예보실황
var spaceDataUrl = 'ForecastSpaceData'; //동네예보
var serviceKey = 'iXV4vLvb8wkopH3ekhwxmhhcI0033T3I3aciC7tz%2FYH9K0G0xmDsoGL7zO%2FQHyQ0Del7YotVrbI7p2ndjgZH4w%3D%3D';
//const serviceKey = '%2Bs9nRw4h0UKa3c7vOblwxiBORZOYJTXXaN6rXFZgOpPvaU672fl1Yunf8Qku9JA59UrFSqG6owC8armj6Oky5w%3D%3D';
var nx = '59'; //+)추가할까
var ny = '123';
var cur_time;
var cur_date;
var pop,tmn,tmx,sky,t1h,pty;
var sendStr;



var _type = 'json';
var numOfRows_S = 40; // spaceData
var numOfRows_T = 20; //timeData
function requestGoogle(command) {
  var arr = [];
  arr.push(arguments[1]);
  arr.push(arguments[2]);
  arr.push(arguments[3]);
  arr.push(arguments[4]);
  arr.push(arguments[5]);
  arr.push(arguments[6]);

  return new Promise(function(resolve,reject) {

    fs.readFile('client_secret.json', function(err, content)  {
      if (err) return reject('====request err====='+err);
      // Authorize a client with credentials, then call the Google Calendar API.
      if(command == 'list') {
        authorize(JSON.parse(content), listEvents,arr[0],arr[1]).then(function(data) {
          resolve(data);
        });
      } else if(command == 'insert') {
        authorize(JSON.parse(content), insertEvents,arr[0],arr[1],arr[2]).then(function(data) {
          resolve(data);
        });
      } else if(command == 'delete') {
        authorize(JSON.parse(content), deleteEvents,arr[0],arr[1],arr[2]).then(function(data) {
          resolve(data);
        });
      }else if(command == 'update') {
        authorize(JSON.parse(content), updateEvents,arr[0],arr[1],arr[2],arr[3],arr[4],arr[5]).then(function(data) {
          resolve(data);
        });
      }
    });

});

}

function authorize(credentials, callback) {
  var arr = [];
  arr.push(arguments[2]);
  arr.push(arguments[3]);
  arr.push(arguments[4]);
  arr.push(arguments[5]);
  arr.push(arguments[6]);
  arr.push(arguments[7]);
  return new Promise(function(resolve,reject) {

  var {client_secret, client_id, redirect_uris} = credentials.installed;
  var oAuth2Client = new google.auth.OAuth2(client_id, client_secret, redirect_uris[0]);

  // Check if we have previously stored a token.
  fs.readFile(TOKEN_PATH, function(err, token) {
    if (err) return getAccessToken(oAuth2Client, callback);
    oAuth2Client.setCredentials(JSON.parse(token));
    if(callback==listEvents) {
      callback(oAuth2Client,arr[0],arr[1]).then(function(data) {
        resolve(data);
      });
    }
    else if(callback==insertEvents) {
      callback(oAuth2Client,arr[0],arr[1],arr[2]).then(function(data) {
        resolve(data);
      });
    }
    else if(callback==deleteEvents) {
      callback(oAuth2Client,arr[0],arr[1],arr[2]).then(function(data) {
        resolve(data);
      });
    }else if(callback==updateEvents) {
      callback(oAuth2Client,arr[0],arr[1],arr[2],arr[3],arr[4],arr[5]).then(function(data) {
        resolve(data);
      });
    }
    });
  });
}
function getAccessToken(oAuth2Client, callback) {
  //인증 절차 추가 필요
  var arr = [];
  arr.push(arguments[2]);
  arr.push(arguments[3]);
  arr.push(arguments[4]);
  return new Promise(function(resolve,reject) {
  var authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
  });
  console.log('Authorize this app by visiting this url:', authUrl);
  var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  rl.question('Enter the code from that page here: ', function(code)  {
    rl.close();
    oAuth2Client.getToken(code, function(err, token) {
      if (err) return reject('====getAccessToken err====='+err);
      oAuth2Client.setCredentials(token);
      // Store the token to disk for later program executions
      fs.writeFile(TOKEN_PATH, JSON.stringify(token), function(err) {
        if (err) return reject('====writeFile err====='+err);
        console.log('Token stored to', TOKEN_PATH);
      });
      if(callback==listEvents) {
        callback(oAuth2Client,arr[0],arr[1]).then(function(data) {
          resolve(data);
        });
      }
      else if(callback==insertEvents) {
        callback(oAuth2Client,arr[0],arr[1],arr[2]).then(function(data) {
          resolve(data);
        });
      }
      else if(callback==deleteEvents) {
        callback(oAuth2Client,arr[0],arr[1],arr[2]).then(function(data) {
          resolve(data);
        });
      }
    });
  });
  });
}

function listEvents(auth,start_t,end_t) {
  return new Promise(function(resolve,reject) {
  var list='&';
  var calendar = google.calendar({version: 'v3', auth});
  console.log('listEvent',start_t,end_t);
  calendar.events.list({
    calendarId: 'primary',
    timeMin:start_t,
    timeMax:end_t,
    singleEvents: true,
    orderBy: 'startTime',
  }, function(err, res) {
    if (err) return reject('====list err====='+err);
    var events = res.data.items;
    console.log(new Date());
    if (events.length) {
      //console.log(events.length);
      list+=events.length;
      //console.log(events.summary.length);
      events.map(function(event, i)  {
        var start = event.start.dateTime || event.start.date;
        var end = event.end.dateTime || event.end.date;
        list+=('_'+moment(start,'YYYY-MM-DDTHH:mm:SS+09:00').format("YYYYMMDDHHmm")+'_'+moment(end,'YYYY-MM-DDTHH:mm:SS+09:00').format("YYYYMMDDHHmm")+'_'+ event.summary);
        console.log('%s - %s ', start, event.summary);
      });
      resolve(list);
    } else {
      resolve(list+'!?');
    }
  });
  });
}
function deleteEvents(auth,text,start,end) {
  return new Promise(function(resolve,reject) {
  var calendar = google.calendar({version: 'v3', auth});
  calendar.events.list({
    calendarId: 'primary',
    timeMin:start,
    timeMax:end,
    singleEvents: true,
    orderBy: 'startTime',
  }, function(err, res) {
    if (err) return reject('====delete err====='+err);
    var events = res.data.items;
    console.log("delete eventslnegth : "+events.length);
    if (events.length) {
      events.map((event, i) => {
        console.log(event.summary+event.id);
        if(event.summary == text) {
          calendar.events.delete({
            calendarId: 'primary',
            eventId:event.id
          },function(err,res){
            if(err) return reject('====delete err====='+err);
            resolve('delete'+text+start+end);

          });
        }
      });
    } else {
      resolve('No upcoming events found.');
    }
  });
  });

}
function updateEvents(auth,p_text,p_start,p_end,text,start,end) {

  return new Promise(function(resolve,reject) {
  var calendar = google.calendar({version: 'v3', auth});
  console.log("updateEvents => ",p_text,p_start,p_end,text,start,end);
  var d_event = {
   summary: text,
   start: {
     dateTime: start,
   },
   end: {
     dateTime:end,
   }
 };
  calendar.events.list({
    calendarId: 'primary',
    timeMin:p_start,
    timeMax:p_end,
    singleEvents: true,
    orderBy: 'startTime',
  }, function(err, res) {
    if (err) return reject('====update err====='+err);
    var events = res.data.items;
    console.log("update eventslnegth : "+events.length);
    if (events.length) {
      events.map((event, i) => {
        console.log(event.summary,event.id);
        if(event.summary == p_text) {
          calendar.events.update({
            calendarId: 'primary',
            eventId:event.id,
            resource : d_event
          },function(err,res){
            if(err) return reject('====update err====='+err);
            resolve('update'+text+start+end);

          });
        }
      });
    } else {
      resolve('No upcoming events found.');
    }
  });
  });

}

function insertEvents(auth,text,t_start,t_end) {
  return new Promise(function(resolve,reject) {
  var calendar = google.calendar({version: 'v3', auth});
  var event = {
   summary: text,
   start: {
     dateTime: t_start,
   },
   end: {
     dateTime:t_end,
   }
 };
  calendar.events.insert({
    calendarId : 'primary',
    resource : event
  },function(err,res){
    if(err) return reject('====insert err====='+err);
    resolve('test create');

  });
});
}



function presentTime() {
  return new Promise((resolve, reject) => {
    var d = new Date();
    console.log(d);
    var YYYY = d.getFullYear();
    var MM = ("00" + (d.getMonth() + 1)).slice(-2);
    var DD = ("00" + d.getDate()).slice(-2);
    cur_date = YYYY+MM+DD;
    var hh = ("00" + d.getHours()).slice(-2);
    var mm = ("00" + d.getMinutes()).slice(-2);
    cur_time = hh+mm;

    resolve();
  });
}
function queryMaker(data,numOfRows,base_date,base_time) {
  return new Promise((resolve,reject)=> {
    var queryP = data + '?' + 'ServiceKey=' + serviceKey;
    queryP += '&nx='+nx;
    queryP += '&ny='+ny;
    queryP += '&base_date='+base_date;
    queryP += '&base_time='+base_time;
    queryP += '&_type='+_type;
    queryP += '&numOfRows='+numOfRows;

    resolve(queryP);
  });

}
function spaceParsing(j_body,len) {
  return new Promise(async(resolve,reject) =>{
      var popMax=-1, pop_body;
      // if(len >= 40){
      //   len = 40;
      // }
      presentTime().then(()=>{
        var p_date=cur_date+'';
        console.log(j_body);
         if(cur_time>='2311') {
           p_date=Number(p_date)+1;
           p_date=String(p_date);
         }console.log(p_date + cur_time);
        for(var i =0;i<len;i++) {

          //console.log('test'+j_body.response.body.items.item[0].category);
          if(j_body.response.body.items.item[i].category === 'TMN'&&
                      (j_body.response.body.items.item[i].fcstDate).toString() === p_date) {
            console.log(len+"===tmn==="+j_body.response.body.items.item[i].fcstDate);
            tmn = j_body.response.body.items.item[i];
            //console.log(tmn);
          } else if(j_body.response.body.items.item[i].category === 'TMX' &&
                      (j_body.response.body.items.item[i].fcstDate).toString() === p_date) {
            console.log(len+"===tmx==="+j_body.response.body.items.item[i].fcstDate);
            tmx = j_body.response.body.items.item[i];
            //console.log(tmx);
          } else if(j_body.response.body.items.item[i].category === 'POP'&&
                                popMax<j_body.response.body.items.item[i].fcstValue) {
              if(i<50){
              popMax = j_body.response.body.items.item[i].fcstValue;
              pop_body = j_body.response.body.items.item[i];
            //console.log(j_body.response.body.items.item[i]);
            }
          }
        }
        pop = pop_body;
        //console.log(pop);

      resolve();
      });

  });




}
function t_basicParsing(j_body) { //1시간 후만 정보 파싱
  return new Promise(async(resolve,reject) =>{
    var temp = Math.floor((j_body.fcstTime)/100)-Math.floor(j_body.baseTime/100);
    if(temp === 1 || Math.abs(temp) === 23) {
      resolve(1);
    } else {
      resolve(0);
    }

  });

}
function timeParsing(j_body,len) {
  return new Promise(async(resolve,reject) =>{
    var temp;
    console.log(j_body);
    for(var i =0;i<len;i++) {
      if(j_body.response.body.items.item[i].category === 'T1H') {
        if(await t_basicParsing(j_body.response.body.items.item[i])) {
          t1h = j_body.response.body.items.item[i];
          //console.log(t1h);
        }
        //console.log('t1h');
      } else if(j_body.response.body.items.item[i].category === 'SKY') {
        if(await t_basicParsing(j_body.response.body.items.item[i])) {
          sky = j_body.response.body.items.item[i];
          //console.log(sky);
        }
        //console.log('sky');
      } else if(j_body.response.body.items.item[i].category === 'PTY') {
        if(await t_basicParsing(j_body.response.body.items.item[i])) {
          pty = j_body.response.body.items.item[i];
          //console.log(pty);
        }
        //console.log('pty');
      }
    }
    resolve();
  });


}
function getRowLen(dataUrl,date,time) {
  return new Promise(async(resolve, reject) => {
    var j_body;
    dataUrl = queryMaker(dataUrl,10,date,time).then(async(dataUrl) =>{
      console.log(url+dataUrl);
      request({
          url: url + dataUrl,
          method: 'GET'
      }, function (error, response, body) {
        if(!error&&response.statusCode==200) {

          j_body = JSON.parse(body);
          if (j_body.response.header.resultCode === '0000') {
            resolve(j_body.response.body.totalCount);
          } else {
            console.log('error : '+j_body.response.header.resultMsg);
            reject('error');
          }

          }
      });
    }) ;

  })
}
function weatherRequest(dataUrl,date,time) {
  return new Promise(async(resolve, reject) => {
    var j_body;
    await getRowLen(dataUrl,date,time).then(async(len)=>{

      console.log(len);
      if(len === -1) {
        console.log('error : len');
        return -1;
      }
      await queryMaker(dataUrl,len,date,time).then(async(dataUrl)=>{
        request({
            url: url + dataUrl,
            method: 'GET'
        }, await function (error, response, body) {


          if(!error&&response.statusCode==200) {
            //console.log(url+dataUrl);
            j_body = JSON.parse(body);
            dataUrl = dataUrl.slice(8,9);
            if(dataUrl === 'S') { //space
              spaceParsing(j_body,len).then(function() {
                console.log(pop,tmx,tmn);
                  resolve();
              });
            } else if(dataUrl === 'T') { //time

              timeParsing(j_body,len).then(function() {
                console.log(pty,sky,t1h);
                  resolve();
              })
            }
            }
        });
      });

    });


  });
}
function init() {
  return new Promise(async (resolve,reject) => {
    var url_basetime;
    var url_basedate;

    await presentTime();
    url_basetime = cur_time;
    url_basedate = cur_date;
    if(url_basetime>='2311' || url_basetime<'0211') { // 현재시간이 spaceData 공백시간 일때
      if(url_basetime >='0000' && url_basetime<'0211') {
        //url_basedate-='1';
        url_basedate= Number(url_basedate)-1;
        url_basedate= String(url_basedate);
      }
        url_basetime = '2300';
      await weatherRequest(spaceDataUrl,url_basedate,url_basetime); //TMN, TMX,POP가져오기


    } else {
      url_basetime = '0200';
      await weatherRequest(spaceDataUrl,url_basedate,url_basetime); //TMN, TMX가져오기

      url_basetime = cur_time;
      if(url_basetime.slice(0,2)%3===2) {
        if(url_basetime.slice(-2)<=11) {
          url_basetime = ('00'+(url_basetime.slice(0,2)-'3')).slice(-2) + '00';
        }else {
          url_basetime = ('00'+url_basetime.slice(0,2)).slice(-2) + '00';
        }
      } else if(url_basetime.slice(0,2)%3===1) {
        url_basetime = ('00'+(url_basetime.slice(0,2)-'2')).slice(-2) + '00';
      } else {
        url_basetime = ('00'+(url_basetime.slice(0,2)-'1')).slice(-2) + '00';
      }
      await weatherRequest(spaceDataUrl,url_basedate,url_basetime); //pop   POP가져오기
    }

    url_basetime = cur_time;
    url_basedate = cur_date;
    if(url_basetime<'0046') {
      url_basedate-='1';
      url_basetime = '2330';
    } else {
      if(url_basetime.slice(-2)<46) {
        url_basetime=('00'+(url_basetime.slice(0,2)-1)).slice(-2)+'30';
      } else {
        url_basetime =('00'+ url_basetime.slice(0,2)).slice(-2)+'30';
      }
    }
      await weatherRequest(timeDataUrl,url_basedate,url_basetime);

      resolve('init end');
  })
}
function Send() {
  return new Promise(async(resolve, reject) => {
    //console.log(pop,tmx,tmn,pty,sky,t1h);
    //console.log('cur_time'+(cur_time.slice(-2)-1+'45'));

    console.log('====================send==========================');
    sendStr= await sendMaker();
    console.log('sendStr = ',sendStr);


    resolve(sendStr);

  });
}
function sendMaker() {
  return new Promise(async(resolve,reject) =>{
    var str=''; //= (cur_date+cur_time+'\n'+pop.fcstTime+','+pop.fcstValue+'/'+tmx.fcstValue+'/'+tmn.fcstValue+'/\n'+pty.baseTime+':'+pty.fcstValue+'/'+sky.fcstValue+'/'+t1h.fcstValue);
    //  var str = pop + tmn + tmx + sky + t1h + pty;
    //pop = 강수 확률, 강수 시간대 포함
    // tmx,tmn 최저 최고 기온
    // pty 강수형태 0:없음, 1:비, 2:비/눈, 3:눈, 4:소나기
    // sky 하늘 상태  1:맑음, 3:구름 많음, 4:흐림 (2.삭제 2019.06)
    // t1h 현재 기온
    str+='_'+pop.fcstTime+':'+pop.fcstValue;
    str+='_'+tmx.fcstValue;
    str+='_'+tmn.fcstValue;
    switch(pty.fcstValue) {
      case 0:
        str+='_-';
        break;
      case 1:
        str+='_rain';
        break;
      case 2:
        str+='_sleet';
        break;
      case 3:
        str+='_snow';
        break;
      case 4:
        str+='_shower';
        break;
      default:
        str+='_=pe=';
        break;
    }
    switch(sky.fcstValue) {
      case 1:
        str+='_clear';
        break;
      case 2:
        str+='_s-cloud'; //삭제 예정
        break;
      case 3:
        str+='_cloud';
        break;
      case 4:
        str+='_m-cloudy';
        break;
      default:
        str+='_=se=';
        break;
    }
    str+='_'+t1h.fcstValue;
    console.log(str);
    //console.log('sendMaker = ',str);
    resolve(str);
  });

}
function Cron_Scheduler(date_str,dataUrl) {
  return new Promise(function(resolve,reject) {
    cron.schedule(date_str, async function () {
        await presentTime().then(async function(){
          var b_time;
          if(dataUrl === timeDataUrl) {
            b_time = cur_time.slice(0,2)+'00';
          }else if(dataUrl === spaceDataUrl) {
            b_time = cur_time.slice(0,2)+'30';
          }
          await weatherRequest(dataUrl,cur_date,b_time).then(()=> {
            resolve();
          });
          sendMaker();
          //await Send();
          //console.log(`${date_str}: `,year,month,day,hour,minutes);
        });

    }).start();
  });


}
function  main(){
  init().then(function(data) {
    console.log('init state = ',data);
    sendMaker();
  });

  //socket.write(''+sendMaker());
  Cron_Scheduler('46 */1 * * *',timeDataUrl); // 단기 예보
  Cron_Scheduler('11 2,5,8,11,17,20,23 * * *',spaceDataUrl); // 동네 예보

}


main();

var server = net.createServer(function(socket) {
  //서버를 생성
  console.log(socket.address().address+'connected');
  // socket.connect(function(){
  //   console.log('connect');
  // });
  socket.on('data',function(data) {
    //client로부터 받아온 데이터를 출력
    console.log("Android connect");
    console.log('rcv : '+data);
    if(String(data).indexOf('Android')!=-1) { // Android_insert_go to movie_201905231800_201905232000
      var dataStr = String(data).split('_');
      if(dataStr[1]=='ouath') {
        //getAccessToken
      } else if(dataStr[1]=='list') {
        requestGoogle('list', moment(dataStr[2],'YYYYMMDDHHmm').format('YYYY-MM-01T00:00:00+09:00'),
                              moment(dataStr[3],'YYYYMMDDHHmm').format('YYYY-MM-DDT23:59:59+09:00'))
                              .then(function(data) {
                                  socket.write(data);
                                    console.log(data);
                                    socket.destroy();
                                    isChangeList = true;
                                    }
                                  );
      } else if(dataStr[1]=='insert') {
        requestGoogle(dataStr[1],dataStr[2],
                              moment(dataStr[3],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00'),
                              moment(dataStr[4],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00')
                            ).then(function(data) {
                              socket.write(data);
                              console.log(data);
                              socket.destroy();
                              isChangeList = true;
                            });

      } else if(dataStr[1]=='delete') {
        //var summaryText=data.slice();
        //var startText=data.slice();
        //var endText=data.slice();
        requestGoogle(dataStr[1],dataStr[2],
                              moment(dataStr[3],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00'),
                              moment(dataStr[4],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00')
                            ).then(function(data) {
                              socket.write(data);
                              console.log(data);
                              socket.destroy();
                              isChangeList = true;
                            });
      } else if(dataStr[1]=='update') { //7개
        //var summaryText=data.slice();
        //var startText=data.slice();
        //var endText=data.slice();
        requestGoogle(dataStr[1],dataStr[2],
                              moment(dataStr[3],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00'),
                              moment(dataStr[4],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00'),
                              dataStr[5],
                              moment(dataStr[6],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00'),
                              moment(dataStr[7],'YYYYMMDDHHmm').format('YYYY-MM-DDTHH:mm:ss+09:00')
                            ).then(function(data) {
                              socket.write(data);
                              console.log(data);
                              socket.destroy();
                              isChangeList = true;
                            });
      }else if(dataStr[1]=='weather') {
        Send().then(function(sendStr){
          socket.write(sendStr);
          socket.destroy();
        });
      }

    } else if(String(data).indexOf('Arduino')!=-1) {
      var arduinoData='';
      console.log("Arduino connect");
      var list_start = moment().format('YYYY-MM-DDTHH:mm:ss+09:00');
      var list_end = moment().add(12,'hours').format('YYYY-MM-DDTHH:mm:ss+09:00');
      console.log(list_start,list_end);
      if(String(data).indexOf('schedule')!=-1 || isChangeList) {
        Send().then(function(sendStr){
          arduinoData+=moment().format('HH:mm:ss');
          arduinoData+=sendStr;

          requestGoogle('list', list_start,list_end).then(function(data) {
                                                arduinoData+=data;
                                                isChangeList = false;
                                                console.log(arduinoData);
                                                socket.write(arduinoData);
                                                socket.destroy();
                                              }
                                            );
          });
      } else {
        Send().then(function(sendStr){
          arduinoData+=moment().format('HH:mm:ss');
          arduinoData+=sendStr;
          console.log(arduinoData);
          socket.write(arduinoData);
          socket.destroy();
        });

      }

    }else {
      Send().then(function(sendStr){
        console.log('not data');
        socket.write('not');
        socket.destroy();

      });
    }
  });

  socket.on('close',function() {
    //socket.destroy();
    socket.destroy();
    console.log('client close');
  });
  //socket.write('welcome to server');
  //접속시 메세지 출력
});

server.on('error',function(err) {
  //에러시 메세지 출력
  console.log('err' + err);
});



server.listen(3000,function() {
  //접속 가능할때까지 대기
  console.log('linsteing on 3000..');
});
/*
var http = express();

http.get('/', function (req, res) {
  res.send(list);
});

http.listen(3000, function() {
  console.log('Start Server:3000');
});
*/

const express = require("express");

const app = express();
var fs = require("fs");
var http = require("http");
var connectedUser = 0;
let typingUsers = new Set();
let blockedUsers = [];
let blockedUsersCount = [];
let messages = [];
let id = 0;
let badWrds = ['كسم', 'انيكك', 'لوطي', 'كلللب', 'طيز',
    "فك", 'كس'
];
const server = app.listen(8080, function() {
    var host = server.address().address;
    var port = server.address().port;
    console.log(server.address().address);
    console.log("Rest API at http://%s:%s", host, port);


})
var io = require("socket.io")(server);

app.get("/chat", function(req, res) {
    //messages.push({ "id": 1, "userId": 5, "name": "Wari ", "userName": "wari", "message": "hgg", "avatar": "upload/profiles/11.jpg", "admin": true, "reply": null }, { "id": 1, "userId": 11, "name": "Wari ", "userName": "wari", "message": "hgg", "avatar": "upload/profiles/11.jpg", "admin": true, "reply": null }, { "id": 1, "userId": 45, "name": "Wari ", "userName": "wari", "message": "hgg", "avatar": "upload/profiles/11.jpg", "admin": false, "reply": null });
    let finalMessages = [];
    console.log(messages.length);
    let max = 50;
    console.log(max);
    for (let i = messages.length; max >= 0; i--) {
        const element = messages[i];
        if (element != null) {
            finalMessages.unshift(element)
        }
        max--;
    }
    res.send(finalMessages);
})
app.get("/blockedUsers", function(req, res) {
    // blockedUsers.push({ "userId": 5, "userName": "wari", "avatar": "upload/profiles/11.jpg" });

    res.send(blockedUsers);
})


io.on("connection", (socket) => {
    console.log("connetetd");
    console.log(socket.id, "has joined");
    io.emit('connected-user', connectedUser);
    connectedUser = connectedUser + 1;
    io.emit("typing-r", {
        "type": typingUsers.size
    });
    socket.on("disconnect", () => {
        connectedUser = connectedUser - 1;
        console.log("Disconnected", socket.id);
        typingUsers.delete(socket.id);
        io.emit('connected-user', 0);

    });
    socket.on("typing", (isTyping) => {
        if (isTyping["type"]) {
            typingUsers.add(isTyping["id"]);
            io.emit("typing-r", {
                "type": typingUsers.size
            });
        } else {
            typingUsers.delete(isTyping["id"]);
            io.emit("typing-r", {
                "type": typingUsers.size
            });
        }

    });
    socket.on("delete-message", (messageId) => {
        for (let i = 0; i < messages.length; i++) {
            if (messages[i]['id'] == messageId) {
                io.emit("delete-message-r", messages[i]['id']);
                messages.splice(i);

            }
        }
    });

    socket.on("clear-chat", () => {
        messages = [];
        io.emit("clear-chat-r", true);
    });

    socket.on("block-user", (user) => {
        blockedUsers.push(user);
        io.emit("block-user-r", { 'userId': user['userId'] });
    });
    socket.on("block-all-user", () => {
        blockedUsers = [];
        blockedUsersCount = [];
        // io.emit("block-user-r", { 'userId': user['userId'] });
    });
    socket.on("message", (msg) => {
        let bloced = false;
        id++;
        let mes = msg['message'].toString().split(' ');


        for (let index = 0; index < blockedUsers.length; index++) {
            console.log(typeof msg['userId']);
            console.log(typeof blockedUsers[index]['userId']);
            if (msg['userId'] == blockedUsers[index]['userId']) {
                bloced = true;
            }
        }
        for (let mesIndex = 0; mesIndex < mes.length; mesIndex++) {
            const word = mes[mesIndex];


            for (let index = 0; index < badWrds.length; index++) {
                // console.log(typeof msg['message'] + 'message');
                // console.log(msg['message'].includes('كلب'));

                //let start = mes.slice(0, msg['message'].indexOf(badWrds[index]));
                // let end = mes.slice(msg['message'].indexOf(badWrds[index]) + badWrds[index].length, msg.length);

                //let start = word.slice(0, 1);
                //let end = word.slice(msg['message'].indexOf(badWrds[index]) + badWrds[index].length, msg.length);

                if (word.includes(badWrds[index])) {
                    let inCode = badWrds[index];
                    for (let i = 1; i < badWrds[index].length; i++) {
                        inCode = inCode.replace(badWrds[index][i], '*');

                    }
                    // msg.indexOf('كلب');
                    // console.log(msg['message'].indexOf('كلب'));
                    //console.log(msg['message'].lastIndexOf('كلب'));
                    //  console.log(msg['message'].slice(msg['message'].indexOf('كلب'), -msg['message'].lastIndexOf('كلب')));

                    console.log('start ');
                    console.log('end ');
                    mes[mesIndex] =
                        inCode;


                }
            }
        }
        msg['message'] = mes.join(' ');
        var message = {
            'id': id,
            'userId': msg['userId'],
            'name': msg['name'],
            'userName': msg['userName'],
            'message': msg["message"],
            'avatar': msg['avatar'],
            'admin': msg['admin'],
            'reply': msg['reply'],

        };
        console.log(message);
        if (!bloced) {
            messages.push(message);
            io.emit("message-r", message);
            console.log(msg);
            if (msg['message'].startsWith("animont") || msg['message'].startsWith("انيمونت")) {
                io.emit("message-r", {
                    'id': id,
                    'userId': 1,
                    'name': 'Animont',
                    'userName': 'animont',
                    'message': 'هلا',
                    'avatar': "https://animont.net/animont/upload/profiles/11.jpg",
                    'admin': true,
                    'reply': null
                });
            }
        } else {
            if (blockedUsersCount.length > 0) {


                if (blockedUsersCount.indexOf(msg['userId'])) {


                    // io.emit("message-r", {
                    //     'id': id,
                    //     'userId': 1,
                    //     'name': 'Animont',
                    //     'userName': 'animont',
                    //     'message': 'يبدو لي انه قد تم حظر , في حال كنت تشكك بقرار المشرفين يمكنك ان تقدم شكوى لمطور التطبيق مونت عن طريق حسابات التطبيق على مواقع التواصل الاجتماعي او الإيميل.',
                    //     'avatar': msg['avatar'],
                    //     'admin': true,
                    //     'reply': {
                    //         'userId': msg['userId'],
                    //         'messageId': id,
                    //         'avatar': msg['avatar'],
                    //         'userName': msg['userName'],
                    //         'name': msg['name'],
                    //         'message': msg["message"],
                    //     }
                    // });
                    // blockedUsersCount.push(msg['userId']);
                }

            } else {
                io.emit("message-r", {
                    'id': id,
                    'userId': 1,
                    'name': 'Animont',
                    'userName': 'animont',
                    'message': 'يبدو لي انه قد تم حظر , في حال كنت تشكك بقرار المشرفين يمكنك ان تقدم شكوى لمطور التطبيق مونت عن طريق حسابات التطبيق على مواقع التواصل الاجتماعي او الإيميل.',
                    'avatar': msg['avatar'],
                    'admin': true,
                    'reply': {
                        'userId': msg['userId'],
                        'messageId': id,
                        'avatar': msg['avatar'],
                        'userName': msg['userName'],
                        'name': msg['name'],
                        'message': msg["message"],
                    }
                });
                blockedUsersCount.push(msg['userId']);
            }

        }


    });
});
// app.get("/chat", function(req, res) {
//         // fs.readFile(__dirname + "/" + "chat.json", 'UTF-8', function(err, data) {
//         //     console.log(data);
//         //     res.end(data);
//         // });
//         // document.write(messages);
//         console.log(messages);
//         //res.end(messages);
//     })
// fs.writeFile("chat.json", JSON.stringify([message]), (err) => {

//     if (err) throw err;
//     console.log("done writing...");
// });
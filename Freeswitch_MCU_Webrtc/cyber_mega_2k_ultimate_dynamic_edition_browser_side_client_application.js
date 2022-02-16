// For Multiparty conference trials one can use  Cyber Mega Phone 2K Ultimate Dynamic Edition browser side client application by Digium.

let socket = new JsSIP.WebSocketInterface('wss://' + this.host + ':7443');
let uri = 'sip:' + this.id + '@' + this.host;
document.getElementById("accountId").placeholder = "video";
document.getElementById("accountId").value = "altanai";

document.getElementById("accountName").value = "";

document.getElementById("accountPassword").placeholder = "pass";
document.getElementById("accountPassword").value = "password";

document.getElementById("accountHost").placeholder = "localhost";
document.getElementById("accountHost").value = "10.176.2.43";

document.getElementById("accountRegister").checked = true;

document.getElementById("extension").placeholder = "video-conf";
document.getElementById("extension").value = "350000-screen";
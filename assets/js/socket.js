// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("chat:lobby", {})
let messageInput = document.querySelector("#message-input")
let usernameInput = document.querySelector("#username")
let messagesContainer = document.querySelector("#messages")
let onlineLabel = document.querySelector("#online")
let online = 0
messageInput.addEventListener("keypress", event => {
  if(event.keyCode === 13){
    channel.push("new_msg", {text: messageInput.value, username: "@"+usernameInput.value})
    messageInput.value = ""
  }
})

channel.on("new_msg", payload => {
  let messageItem = document.createElement("li");
  messageItem.innerText = `${payload.comment.username}: ${payload.comment.text}`
  messagesContainer.appendChild(messageItem)
})

channel.on("presence_state", payload => {
  updateOnlineCount(payload.presence_list)
})

function updateOnlineCount(presence_list) {
  enterOrLeave (online,Object.keys(presence_list).length)
  online = Object.keys(presence_list).length
  onlineLabel.innerHTML = "Users online: "+online
}
function enterOrLeave(online,newOnline){
  let messageItem = document.createElement("li");
  if (online < newOnline) {
    messageItem.innerHTML = `<b>Um tanga entrou no chat!`
    messagesContainer.appendChild(messageItem)
  }else if (online > newOnline){
    messageItem.innerHTML = `<b>Um tanga saiu do chat!`
    messagesContainer.appendChild(messageItem)
  }
}

function renderComments (comments){
  const renderedComments = comments.map(comment => {
    let messageItem = document.createElement("li");
    messageItem.innerText = `${comment.username}: ${comment.text}`
    messagesContainer.appendChild(messageItem)
  });
}

function joinChat (comments){
  let messageItem = document.createElement("li");
  messageItem.innerHTML = `<b>Voce entrou no chat!`
  messagesContainer.appendChild(messageItem)
}

channel.join()
  .receive("ok", resp => {
        console.log("Joined the channel")
        messagesContainer.innerHTML = "";
        renderComments (resp.comments)
        //joinChat()
      })

  .receive("error", resp => { console.log("Unable to join", resp) })



export default socket

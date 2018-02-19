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

function renderComments (comments){
  const renderedComments = comments.map(comment => {
    let messageItem = document.createElement("li");
    messageItem.innerText = `${comment.username}: ${comment.text}`
    messagesContainer.appendChild(messageItem)
  });
}

channel.join()
  .receive("ok", resp => {
        console.log("Joined the channel")
        messagesContainer.innerHTML = "";
        renderComments (resp.comments)})
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

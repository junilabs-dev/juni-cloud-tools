/**
 * Handles the MESSAGE event triggered in Google Chat.
 *
 * @param {Object} event - The Google Chat event object.
 */
function onMessage(event) {
  const senderName = event.space.type === "DM" ? "You" : event.user.displayName;
  const replyText = `${senderName} said "${event.message.text}"`;
  
  return { text: replyText };
}

/**
 * Handles the ADDED_TO_SPACE event in Google Chat.
 *
 * @param {Object} event - The Google Chat event object.
 */
function onAddToSpace(event) {
  let welcomeMsg = "";

  if (event.space.singleUserBotDm) {
    welcomeMsg = `Thank you for adding me to a DM, ${event.user.displayName}!`;
  } else {
    const spaceName = event.space.displayName || "this chat";
    welcomeMsg = `Thank you for adding me to ${spaceName}`;
  }

  if (event.message && event.message.text) {
    welcomeMsg += ` and you said: "${event.message.text}"`;
  }
  
  console.log(`Helper Bot successfully joined: ${event.space.name}`);
  
  return { text: welcomeMsg };
}

/**
 * Handles the REMOVED_FROM_SPACE event in Google Chat.
 *
 * @param {Object} event - The Google Chat event object.
 */
function onRemoveFromSpace(event) {
  const spaceLeft = event.space.name || "this chat";
  console.info(`Bot has been removed from ${spaceLeft}`);
}

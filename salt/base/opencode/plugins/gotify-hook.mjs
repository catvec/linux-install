import { readFile } from 'fs/promises';

async function readJsonFile(filePath) {
  const content = await readFile(filePath, 'utf8');
  return JSON.parse(content);
}

async function sendGotifyNotification(notification, appToken, serverUrl) {
  const url = serverUrl || 'http://gotify.bagel.internal';

  const response = await fetch(`${url}/message?token=${appToken}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(notification)
  });

  if (!response.ok) {
    throw new Error(`Gotify API error: ${response.status} ${response.statusText}`);
  }
}

function buildNotification(permission, sessionId) {
  const permType = permission.type || 'unknown';

  const body = `
**Opencode session:** \`${sessionId}\`

**Permission type:** \`${permType}\`
`.trim();

  return {
    title: `Permission: ${permType}`,
    message: body,
    priority: 8
  };
}

export const NotificationPlugin = async (ctx) => {
  const config = await readJsonFile('/opt/opencode-plugins/gotify-config.json');

  const { server_url, app_token } = config;
  if (!app_token) {
    console.error('[Gotify Hook] Missing app_token in config');
    return {};
  }

  if (!server_url) {
    console.error('[Gotify Hook] Missing server_url in config');
    return {};
  }

  return {
    event: async ({ event }) => {
      if (event.type === "permission.asked") {
        try {
          const { permission, id } = event;
          const notification = buildNotification(permission, id);
          await sendGotifyNotification(notification, app_token, server_url);
        } catch (error) {
          console.error('[Gotify Hook] Error:', error.message);
        }
      }
    },
  };
};

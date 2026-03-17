import { readFile } from 'fs/promises';

export { readFile };

interface Permission {
  type?: string;
  [key: string]: unknown;
}

interface Notification {
  title: string;
  message: string;
  priority: number;
}

interface GotifyConfig {
  server_url: string;
  app_token: string;
  [key: string]: unknown;
}

interface EventData {
  type: string;
  permission?: Permission;
  id?: string;
  [key: string]: unknown;
}

interface PluginContext {
  [key: string]: unknown;
}

interface PluginReturn {
  event: (data: { event: EventData }) => Promise<void>;
}

async function readJsonFile(filePath: string): Promise<unknown> {
  const content = await Bun.file(filePath).text();
  return JSON.parse(content);
}

async function sendGotifyNotification(
  notification: Notification,
  appToken: string,
  serverUrl?: string
): Promise<void> {
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

function buildNotification(permission: Permission, sessionId: string): Notification {
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

export const NotificationPlugin = async (ctx: PluginContext): Promise<PluginReturn> => {
  let config: GotifyConfig;

  try {
    const rawConfig = await readJsonFile('/opt/opencode-plugins/gotify-config.json');
    config = rawConfig as GotifyConfig;
  } catch (error) {
    console.error('[Gotify Hook] Error reading config file:', error instanceof Error ? error.message : 'Unknown error');
    return { event: async () => {} };
  }

  const { server_url, app_token } = config;
  if (!app_token) {
    console.error('[Gotify Hook] Missing app_token in config');
    return { event: async () => {} };
  }

  if (!server_url) {
    console.error('[Gotify Hook] Missing server_url in config');
    return { event: async () => {} };
  }

  return {
    event: async ({ event }: { event: EventData }): Promise<void> => {
      if (event.type === "permission.asked") {
        try {
          const { permission, id } = event;
          const notification = buildNotification(
            permission as Permission,
            (id as string) || 'unknown'
          );
          await sendGotifyNotification(notification, app_token, server_url);
        } catch (error) {
          console.error('[Gotify Hook] Error:', error instanceof Error ? error.message : 'Unknown error');
        }
      }
    },
  };
};

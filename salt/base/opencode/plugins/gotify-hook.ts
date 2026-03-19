import { readFile } from "fs/promises";
import { homedir } from "os";
import { resolve } from "path";

const CONFIG_FILE = resolve(homedir(), ".config/opencode/plugins/gotify-config.json");

function log(client, obj) {
    client.app.log({
        body: {
            service: "gotify-hook",
            ...obj
        },
    });
} 

export const NotificationPlugin = async ({ project, client }) => {
    const { server_url, app_token } = JSON.parse(await readFile(CONFIG_FILE));

    let sessionName = project.worktree;

    return {
        event: async ({ event }): Promise<void> => {
            try {
                switch (event.type) {
                    case "session.updated":
                        sessionName = event.properties.info.title;
                        break;
                    case "permission.asked":
                        /** permission.asked={"type":"permission.asked","properties":{"id":"per_d03bfea6d001dVH3Hqgl3VdVxv","sessionID":"ses_2fc413eb8ffegm39kU1rfMQRBz","permission":"bash","patterns":["echo hello"],"metadata":{},"always":["echo *"],"tool":{"messageID":"msg_d03bfe5b0001nzN3xS1zBJLC6I","callID":"7VhL1m9jjdfvd67U3bxAeUrZAsW2XT63"}}} */
                        
                        // Make POST notification request
                        const { permission, patterns, always } = event.properties;
                        const cmd = patterns.join(" ");

                        const resp = await fetch(`${server_url}/message`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'Authorization': `Bearer ${app_token}`,
                            },
                            body: JSON.stringify({
                                title: `Permission Requested ${project.worktree}`,
                                message: `\
**Session:** \`${sessionName}\`  
**Command:**  
\`\`\`shell
${cmd}
\`\`\``,
                                extras: {
                                    "client::display": {
                                        contentType: "text/markdown",
                                    },
                                },
                            }),
                        });

                        if (!resp.ok) {
                            throw new Error(`Gotify API error: ${resp.status} ${resp.statusText}`);
                        }
                        break;
                }
            } catch (e) {
                log(client, {
                    level: "error",
                    message: `Failed to handle ${event.type}: ${e} ${e.stack}`
                });
            }
        },
    };
};

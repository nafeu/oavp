import { spawn } from 'child_process';
import { chmod } from 'fs/promises';
import { access, constants } from 'fs';
import { promisify } from 'util';
import webview from 'webview';
import { WEBSERVER_PORT } from '../../constants.mjs';

const accessAsync = promisify(access);

let webviewProcess = null;

const ensureWebviewBinaryPermissions = async () => {
  try {
    // Check if binary exists and has execute permissions
    await accessAsync(webview.binaryPath, constants.X_OK);
  } catch (error) {
    // If it doesn't have execute permissions, add them
    try {
      await chmod(webview.binaryPath, 0o755);
      console.log('[ oavp-commander:webview ] Set execute permissions on webview binary');
    } catch (chmodError) {
      console.warn('[ oavp-commander:webview ] Could not set execute permissions:', chmodError.message);
    }
  }
};

const setupWebview = () => {
  const url = `http://localhost:${WEBSERVER_PORT}`;

  console.log(`[ oavp-commander:webview ] Opening webview at ${url}`);

  // Wait a bit for the server to be ready before opening the webview
  setTimeout(async () => {
    try {
      // Ensure the webview binary has execute permissions
      await ensureWebviewBinaryPermissions();

      const options = {
        title: 'OAVP Commander',
        width: 1200,
        height: 800,
        url: url,
        resizable: true,
        debug: false
      };

      // Convert options to command-line arguments
      const args = webview.optionsToArgv(options);

      // Spawn the webview process
      webviewProcess = spawn(webview.binaryPath, args, {
        cwd: process.cwd(),
      });

      webviewProcess.on('error', (err) => {
        console.error('[ oavp-commander:webview ] Failed to start webview:', err);
        console.log('[ oavp-commander:webview ] You can manually open http://localhost:' + WEBSERVER_PORT + ' in your browser');
        webviewProcess = null;
      });

      webviewProcess.on('exit', (code) => {
        console.log(`[ oavp-commander:webview ] Webview exited with code ${code}`);
        webviewProcess = null;
      });

      // Handle stdout/stderr to prevent unhandled errors
      webviewProcess.stdout?.on('data', () => { });
      webviewProcess.stderr?.on('data', () => { });

    } catch (error) {
      console.error('[ oavp-commander:webview ] Error opening webview:', error);
      console.log('[ oavp-commander:webview ] You can manually open http://localhost:' + WEBSERVER_PORT + ' in your browser');
    }
  }, 1000); // Wait 1 second for server to start
};

export default setupWebview;

const { app, BrowserWindow } = require('electron');
const path = require('path');

let win;

const createWindow = () => {
  win = new BrowserWindow({
    show: false,
    width: 800,
    height: 600,
    backgroundColor: '#222222',
  });

  win.loadURL('https://twitch.tv');
  win.removeMenu();

  win.once('ready-to-show', () => {
    win.show();
    win.setIcon('/usr/share/pixmaps/twitch.png');
  });
};

app.on('ready', () => createWindow());

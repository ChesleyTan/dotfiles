// Copyright (C) 2014 Chesley Tan

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// Author: Chesley Tan (github.com/ChesleyTan)

const UUID = "genericMonitor@chesley.tan"
const Lang = imports.lang;
const Applet = imports.ui.applet;
const GLib = imports.gi.GLib;
const Mainloop = imports.mainloop;
const Settings = imports.ui.settings;

function MyApplet(metadata, orientation, panelHeight, instanceId) {
  this.settings = new Settings.AppletSettings(this, UUID, instanceId);
  this.tick = 0;
  this._init(orientation, panelHeight, instanceId);
}
 
MyApplet.prototype = {
    __proto__: Applet.TextApplet.prototype,
 
    _init: function(orientation, panelHeight, instanceId) {
        Applet.TextApplet.prototype._init.call(this, orientation, panelHeight, instanceId);
        this.settings.bindProperty(Settings.BindingDirection.IN, "commandToExecute", "commandToExecute", this.rebuild, null);
        this.settings.bindProperty(Settings.BindingDirection.IN, "refreshInterval", "refreshInterval", this.rebuild, null);

        try {
            this.set_applet_label(instanceId);
            this.set_applet_tooltip("Generic Monitor");
            this._update_view();
        }
        catch (e) {
            global.logError(e);
        }
     },
 
    on_applet_clicked: function(event) {
    },

    rebuild: function rebuild() {
        //this._update_view();
    },

    _update_view: function() {
        if (!(this.commandToExecute === "")) {
            if (this.tick % this.refreshInterval == 0) {
                try {
                    input = GLib.spawn_command_line_sync(this.commandToExecute);
                    // input is an array, whose first value is true/false, and whose following values are sysout
                    if (input[0])
                        label = input[1].toString().trim();
                } catch (e) {
                    label = this.commandToExecute;
                }
                this.set_applet_label(label + " " + this.tick + " " + this.refreshInterval);
            }
        }
        this.tick++;
        if (this.tick >= 1000000) {
            this.tick = 0;
        }
        // Recursive call
        Mainloop.timeout_add(1000, Lang.bind(this, this._update_view));
    }
    
};
 
function main(metadata, orientation, panel_height, instanceId) {
    return new MyApplet(metadata, orientation, panel_height, instanceId);
}


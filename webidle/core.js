"use strict";

let money = 0;
let income = 0;

let last_time = null;
let total_time = 0;
setInterval(function gameLoop() {
  const current_time = Date.now();
  if (last_time === null) {
    last_time = current_time;
  }
  const delta_time = current_time - last_time;
  total_time += delta_time;
  last_time = current_time;
  updateMyGame(delta_time, total_time);
}, 1000);

function updateMyGame(delta_time, total_time) {
	money+=income;
	document.getElementById("Money").innerHTML = money+"$";
}

function bodyload(){
	income+=1;
	document.getElementById("field").innerHTML = "JS Loaded";
}
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

let selected = 0;
let selection = [];
selection[0] = {name:"Nothing", cost:0, income:0};
selection[1] = {name:"Generator 1", cost:10, income:1};

function updateMyGame(delta_time, total_time) {
	money+=income;
	document.getElementById("Money").innerHTML = money+"$";
}

function createfield(x, y) {
	let iy= 0;
	while(iy++ < y){
		const new_row = document.createElement("tr");
		new_row.id = `y${iy}`;
		let ix= 0;
		while(ix++ < x){
			//console.log(`y${iy}x${ix}`)
			const new_grid = document.createElement("td");
			new_grid.innerHTML = "0"
			new_grid.id = `y${iy}x${ix}`;
			new_row.append(new_grid);
		}
		document.getElementById("field").append(new_row);
	}
	
}

function place_selection(id){
	selected = selection[id];
	document.getElementById("Selection_info").innerHTML = selection[id].name +" Selected";
}

function bodyload(){
	income+=1;
	createfield(3,3);
	place_selection(0)
}
// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function create_time(t_id, startt){
  let text = JSON.stringify({
    timeblock: {
        starttb: startt,
        endtb: startt,
        task_id: t_id        
      },
  });

  console.log(text)

  $.ajax(timeblock_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { console.log(resp) },
    error: (resp) => { console.log(resp)},
  });
}

function stop_click(e) {
  let btn = $(e.target);
//  let start = btn.data('start');
  let stopt = btn.data('stop-time');
  let t_id = btn.data('task-id');
  let id = btn.data('time-id');
  let startt = btn.data('start-time');
  console.log(stopt+" YO "+startt+" SA"+id);

  update_time(id, startt, stopt);
  
}

function start_click(e) {
  let btn = $(e.target);
  let startt = btn.data('start-time');
  let t_id = btn.data('task-id');
  
  console.log("START "+t_id+" "+startt);

  create_time(t_id, startt);
}

function edit_click(e) {
  let btn = $(e.target);
  let startt = btn.data('start-time');
  let id = btn.data('time-id');
  let stopt = btn.data('stop-time');
  console.log("EDIT "+id+" "+stopt);
  console.log("EDIT "+startt);
//  update_time(id, startt, stopt);
}

function update_time(tb_id, starttb, endtb){
  let text = JSON.stringify({
    id : tb_id,
    timeblock: {
        starttb: starttb,
        endtb: endtb
      },
  });

  console.log(text)

  $.ajax(timeblock_path + "/" + tb_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { console.log(resp) },
    error: (resp) => { console.log(resp)},
  });
}

function init() {
  if (!$('.tb-stop')) {
    return;
  }
  console.log("INIT");
  $(".tb-stop").click(stop_click);
  $(".tb-start").click(start_click);
  $(".tb-edit").click(edit_click);
}

$(init);

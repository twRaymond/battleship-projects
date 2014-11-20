<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="com.battleship.domain.PlayerMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" rel="stylesheet" href="html/css/common-style.css">
<link type="text/css" rel="stylesheet" href="html/css/common-button.css">
<link type="text/css" rel="stylesheet" href="html/css/login.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="html/js/jQuery/jquery-1.11.1.min.js" ></script>
<script src="html/js/jQuery/jquery.form.js" ></script>
<title></title>
<script type="text/javascript">
var warships = ["shipAC", "shipB", "shipS", "shipD", "shipPB"];
var mapX = ["A","B","C","D","E","F","G","H","I","L"];
var mapXStr = "ABCDEFGHIL";

var BoutSecCount = 0;
var toStartValue;
var toStartPassThread = false;

function getDateTimeNow() {
	var date = new Date();
	var month = (date.getMonth()+1) > 9 ? (date.getMonth()+1) : "0" + (date.getMonth()+1);
	var day = (date.getDate()+1) > 9 ? (date.getDate()+1) : "0" + (date.getDate()+1);
	var hours = (date.getHours()) > 9 ? (date.getHours()) : "0" + (date.getHours());
	var minutes = (date.getMinutes()) > 9 ? (date.getMinutes()) : "0" + (date.getMinutes());
	var seconds = (date.getSeconds()) > 9 ? (date.getSeconds()) : "0" + (date.getSeconds());
	
	return date.getFullYear() + "/" + month + "/" + day + " " + hours + ":" + minutes + ":" + seconds;
}

function transitionInfoUpdate() {
		var options = {
			id      : 'form_info_update',
			url     : 'room.info.update',
			dataType: 'json',
 			success	: function(obj) {
 				$('#updateDateTime').html(getDateTimeNow());
 				var isRoomMaster = true;
 				
 				//update state
 				$("#state").val(obj.state);
 				// update room player and player state
 				$("#div_player_list").html("");
 				var playerHTML = "<table>";
 				for(var index = 0; index < obj.players.length; ++index){
 					playerHTML += "<tr><td>" + obj.players[index].account + "</td><td>" + getPlayerState(obj.players[index].state) + "</td></tr>";
 					if(obj.players[index].account == $("#account").val() && index != 0){
 						isRoomMaster = false;
 					}
 				}
 				playerHTML += "</table>";
 				$("#div_player_list").html(playerHTML);
 				var updateIndex = isRoomMaster?0:1;
 				if(isRoomMaster){
 					$("#display_btn_start").show();
 					if(obj.players.length == 2){
 						// When all player state is LOCK
 						// Open Room master start btn
 						if(obj.players[0].state == "LOCK" && obj.players[1].state == "LOCK"){
 							$("#btnStart").attr("disabled", false);
 						} else {
 							$("#btnStart").attr("disabled", true);
 						}
 					} 
 				} else {
 					$("#display_btn_start").hide();
 				}
 				if(obj.state == "READY"){
					$('#btnReady').attr('disabled', true);
	 				$("#btnStart").attr("disabled", true);
	 				$("#btnExit").attr("disabled", true);
	 				$("#div_ready_to_start").html("<div width='100%' align='center'>" + obj.goStart + "</div>");
	 				reAllHP();
	 				reMap();
	 				$("#war_history").html("");
 				}
 				if(obj.state == "PLAY"){
	 				$("#div_ready_to_start").html(obj.goStart==0?"START":"");
 					toStartPassThread = false;
	 				$("#btnStart").attr("disabled", true);
 					if(BoutSecCount == 0) {
 						BoutSecCount = Number(obj.boutSec);
 					}
 					if(obj.controlAuth == 0 && isRoomMaster) {
 						$("#div_open_fire").attr("class","div-fire-Y");
 					} else if(obj.controlAuth == 1 && isRoomMaster){
 						$("#div_open_fire").attr("class","div-fire-N");
 					} else if(obj.controlAuth == 1){
 						$("#div_open_fire").attr("class","div-fire-Y");
 					} else {
 						$("#div_open_fire").attr("class","div-fire-N");
 					}
 					try {
	 					if(obj.players[updateIndex].map.updateFlag == 2) {
	 						var hits = obj.players[updateIndex].map.hits;
	 						var hit = hits[hits.length-1];
	 						updateHP(hit, true);
	 					}
 					} catch (e) {
 					
 					}
 				}
 				if(obj.state == "END"){
 					var isWin = obj.players[updateIndex].map.hp != 0;
 					if(isWin){
 						addHistory("", "", "You Win!!", isMe);
 						alert("You Win!!");
 					} else {
 						addHistory("", "", "You Lose!!", !isMe);
 						alert("You Lose!!");
 					}
 					// close open fire auth
 					$("#div_open_fire").attr("class","div-fire-N");
 					onLockProc();
					// Clean LOCK button disabled
					$('#btnReady').attr('disabled', false);
					// rest START button
					$("#btnStart").val("START");
 				}
			}
		};
		$("#form_info_update").ajaxSubmit(options);
}
setInterval(transitionInfoUpdate, 300);

// in json
function updateHP(hit, isMe){
	var tdID = (isMe?"#":"#lx_") + hit.shipID + "_HP";
	var alertMessage = "";
	var alertWarship = "";
 	if(hit.valid){
		$(tdID + getHPGreenSize(hit.shipID, isMe)).attr('class', 'ship_HP_N');
		alertMessage = isMe?"Being attacked !!":"Hit !!";
		alertWarship = $("#chooseWarship option[value='" + hit.shipID + "']").text();
 	} else {
		alertMessage = isMe?"Being attacked !!":"Miss !!";
 	}
 	$("#war_history").prepend(addHistory(hit.location, alertWarship, alertMessage, isMe));
 	// Check The warship hp is zero ?
 	if(hit.shipID != "" && getHPGreenSize(hit.shipID, isMe) == 0){
 		var tmpMsg = "";
 		var tmpShip = $("#chooseWarship option[value='" + hit.shipID + "']").text();
 		if(isMe){
 			tmpMsg = "We " + tmpShip + " is destroy.";
 			$("#war_history").prepend(addHistory("", "", tmpMsg, isMe));
 		} else {
 			tmpMsg = "The enemy " + tmpShip + " is destroy.";
 			$("#war_history").prepend(addHistory("", "", tmpMsg, isMe));		
 		}
 	}
}

function getPlayerState(state){
	if(state == "NONE"){
		return "<div class='div_player_none'>" + state + "</div>";
	} else if(state == "LOCK"){
		return "<div class='div_player_lock'>" + state + "</div>";
	} else {
		return "<div>" + state + "</div>";
	}
}

function getHPGreenSize(shipID, isMe){
	var hp = 0;
	var tdID = (isMe?"#":"#lx_") + shipID + "_HP";
	for(var index = 1; index <= 5 ; index++){
		if($(tdID + index).attr('class') == 'ship_HP_Y'){
			++hp;
		}
	}
	return hp;
}


var submitForm = function(method){
    var formAction = '${pageContext.request.contextPath}/' + method;
    $('#form_start_game').attr('action', formAction);
    $('#form_start_game').submit();
};

$(document)
	.on('click', '#btnStart', function() {
		if($("#btnStart").val() == "STOP"){
	 		$("#btnReady").attr("disabled", true);
			$("#btnStart").val("START");
	  	    var options = {
				id      : 'form_stop_game',
				url     : 'room.stop',
				dataType: 'json',
	 			success	: function(obj) {
	 			}
			};
			$("#form_info_update").ajaxSubmit(options);
			onToStop();
		} else {
	 		$("#btnReady").attr("disabled", false);
			$("#btnStart").val("STOP");
	  	    var options = {
				id      : 'form_start_game',
				url     : 'room.start',
				dataType: 'json',
	 			success	: function(obj) {
	 			}
			};
			$("#form_info_update").ajaxSubmit(options);
			onToStart();
		}
	})
	.on('click', '#btnExit',  function(){
		$("#isExit").val("true");
	    submitForm('room.exit');
	})
	.on('click', '#btnCheckREHP',  function(){
	    reAllHP();
	})
	.on('click', '#btnCheckRENOHP',  function(){
	    reAllNoHP();
	})
	.on('click', '#btnReady', function(){
		if($('#btnReady').attr('value') == "UNLOCK"){
		   onLockProc();
	 	// When player set all warship , Can change state to LOCK.
		} else {
			if($("#warshipAC").val() != "" && $("#warshipB").val() != "" && 
			   $("#warshipS").val() != "" && $("#warshipD").val() != "" && 
		       $("#warshipPB").val() != "") {
		      	onUnlockProc();
	 			procPlayerMap();
			} else {
				alert("You have warship state at wait.");
			}
		}
	})
	.on('click', '.a_blue', function(){
		if($('#btnReady').attr('value') == "LOCK"){
			var warship = $("#chooseWarship").val();
			var direction = $("#" + warship + "_Direction").val();
			var thisLocation = $(this).attr('location');
			var canUse = checkWarshipLocation(thisLocation, direction, warship);
			var updateMap = true;
			if(canUse) {
				var updateWarshipName = "#war"+$("#chooseWarship").val();
				var oldLocation = $(updateWarshipName).val();
				var oldDirection = $(updateWarshipName + "_D").val();
				if(oldLocation != ""){
					if(confirm('Are you check chnage [' + $("#chooseWarship option:selected").text() + ']?')){
						clearWarshipLocation(oldLocation, oldDirection, warship);
					} else {
						updateMap = false;
					}
				}
				if(updateMap){
					setWarshipLocation(thisLocation, direction, warship);
					$(updateWarshipName).val(thisLocation);
					$(updateWarshipName + "_D").val(direction);
					$("#" + warship).attr("class", "div-ship-active");
					$("#" + warship).html("Active");
				}
			}
		}
		for(var index = 0; index < warships.length; ++index){
			if($("#"+warships[index]).attr('class') == 'div-ship-none') {
				$("#chooseWarship").val(warships[index]);
				return;
			}
		}
	})
	.on('click', '.a_red', function() {
		if($("#div_open_fire").attr('class') == "div-fire-Y" && $("#lx_" + $(this).attr('location')).attr('class') == 'td-red'){
	  	    openFire($(this).attr('location'));
		}
	});

function onLockProc(){
	$('#btnReady').attr('value', 'LOCK');
	$('#btnReady').attr('class', 'div_btn_ready_lock');
	$('#myState').val('NONE');
	$("#btnExit").attr("disabled", false);
}

function onUnlockProc(){
	$('#btnReady').attr('value', 'UNLOCK');
	$('#btnReady').attr('class', 'btn_ready_unlock');
	$('#myState').val('LOCK');
	$("#btnExit").attr("disabled", true);
}

function openFire(thisLocation){
	BoutSecCount = $("#boutSec").val();
	var options = {
			id      : 'form_open_fire',
			url     : 'room.openFire?openFireLocation=' + thisLocation,
			dataType: 'json',
	 		success	: function(obj) {
	 		if(obj.valid){
	 			$("#lx_" + obj.location).attr('class', 'td-gray');
	 		} else {
	 			$("#lx_" + obj.location).attr('class', 'td-black');
	 		}
			updateHP(obj, false);
		}
	};
	$("#form_info_update").ajaxSubmit(options);
}

function onToStart() {
	toStartValue = 6;
	toStartPassThread = true;
}

function onToStop(){
	toStartPassThread = false;
}

function toStartPass(){
	if(toStartPassThread) {
		toStartValue = Number(toStartValue) - 1;
		$("#toStartPass").val(toStartValue);
		var options = {
			id      : 'form_to_start_game',
			url     : 'room.to.start',
			dataType: 'json',
			success	: function(obj) {
			}
		};
		$("#form_info_update").ajaxSubmit(options);
	}
}

setInterval(toStartPass, 1000);

function checkWarshipLocation(newLocation, direction, warship) {
	return calWarshipLocation(newLocation, warship, direction, "td-blue", "td-gray", true);
}

function setWarshipLocation(newLocation, direction, warship) {
	calWarshipLocation(newLocation, warship, direction, "td-blue", "td-gray", false);
}

function clearWarshipLocation(newLocation, direction, warship) {
	calWarshipLocation(newLocation, warship, direction, "td-blue", "td-blue", false);
}

function calWarshipLocation(newLocation, warship, direction, checkClass, updateClass, update) {
	var warshipSize = $("#"+warship).attr("warshipSize");
	var tmpX = newLocation.split("_")[0], tmpY = newLocation.split("_")[1];
	var xIndex = mapXStr.indexOf(tmpX);
	var tmpClass = "";
	for(var index = 0; index < warshipSize; ++index){
		if(index == 0){
			tmpClass = $("#" + newLocation).attr("class");
			if(update){
				if(checkClass != tmpClass){
					return false;
				}
			} else { 
				$("#" + newLocation).attr("class", updateClass);
			}
		} else {
			if(direction == "H"){
				newLocation = mapX[(Number(xIndex) + index)] + "_" + tmpY;
			} else { // direction is V
				newLocation = tmpX + "_" + (Number(tmpY) + index);
			}
			tmpClass = $("#" + newLocation).attr("class");
			if(update){
				if(checkClass != tmpClass){
					return false;
				}
			} else { 
				$("#" + newLocation).attr("class", updateClass);
			}
		}
	}
	if(update){
		return true;
	}
}
function procPlayerMap(){
	var tmpMessage = "";
	var sShip = "#";
	var sValue = "%";
	var sLocation = "@";
	for(var shipIndex = 0; shipIndex < warships.length; ++shipIndex){
		if(shipIndex == 0) {
			tmpMessage += warships[shipIndex];
		} else {
			tmpMessage += sShip + warships[shipIndex];
		}
		var startLocation = $("#war" + warships[shipIndex]).val();
		var direction = $("#war" + warships[shipIndex] + "_D").val();
		var warshipSize = $("#"+warships[shipIndex]).attr("warshipSize");
		var tmpX = startLocation.split("_")[0], tmpY = startLocation.split("_")[1];
		var xIndex = mapXStr.indexOf(tmpX);
		for(var index = 0; index < warshipSize; ++index){
			if(index == 0){
				tmpMessage += sValue + startLocation;
			} else {
				if(direction == "H"){
					startLocation = mapX[(Number(xIndex) + index)] + "_" + tmpY;
				} else { // direction is V
					startLocation = tmpX + "_" + (Number(tmpY) + index);
				}
				tmpMessage += sLocation + startLocation;
			}
		}
	}
	$("#myMap").val(tmpMessage);
}

function reMap(){
	for(var indexY = 0; indexY < 10; ++indexY){
		for(var indexX = 0; indexX < 10; ++indexX){
			$("#lx_" + mapX[indexX] +"_" + indexY).attr("class", "td-red");
		}
	}
}

// reset warship hp
function reAllHP() {
	for(var index = 0; index < warships.length; ++index){
		var hp = $("#" + warships[index]).attr("warshipSize");
		for(var hpIndex = 1; hpIndex <= hp; ++hpIndex){
			$("#" + warships[index] + "_HP" + hpIndex).attr('class', 'ship_HP_Y');
			$("#lx_" + warships[index] + "_HP" + hpIndex).attr('class', 'ship_HP_Y');
		}
	}
}

// reset warship hp for test
function reAllNoHP() {
	for(var index = 0; index < warships.length; ++index){
		var hp = $("#" + warships[index]).attr("warshipSize");
		for(var hpIndex = 1; hpIndex <= hp; ++hpIndex){
			$("#" + warships[index] + "_HP" + hpIndex).attr('class', 'ship_HP_N');
			$("#lx_" + warships[index] + "_HP" + hpIndex).attr('class', 'ship_HP_N');
		}
	}
}

function BoutSecListen(){
	if($('#state').val() == "PLAY" && $("#div_open_fire").attr('class') == "div-fire-Y"){
		BoutSecCount = BoutSecCount - 1;
		$("#div_bout_sec").html("<div width='100%' align='center'>" + BoutSecCount + "</div>");
		// auto open fire
		if(BoutSecCount == 0){
			openFire(getValidRandomLocation());
		}
	} else {
		$("#div_bout_sec").html("");
	}
}

function getValidRandomLocation(){
	while(true){
		var tempXY = mapX[getRandomInt(0, 9)] + "_" + getRandomInt(0, 9);
		if($("#lx_" + tempXY).attr("class") == 'td-red'){
			return tempXY;
		}
	}
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function addHistory(tmpLocation, tmpWarship, tmpMessage, isMe){
	var tmpHTML = "<div style='color:" + (isMe?"red":"blue") + "'>";
	tmpHTML += "<label class='history_l'>" + tmpLocation + "</label>";
	tmpHTML += "<label class='history_w'>" + tmpWarship + "</label>";
	tmpHTML += "<label class='history_m'>" + tmpMessage + "</label>";
	tmpHTML += "</div>";
	return tmpHTML;
}

setInterval(BoutSecListen, 1000);

window.onbeforeunload = function(){
	submitForm('room.exit');
};
</script>
<body>
	<form id="form_start_game" name="form_start_game" action="room.start" method="GET">
 		<table>
 		<tr><td>Room (${room.roomName}) -  <span id="updateDateTime"></span></td>
 			<td><input type="button" id="btnReady" name="btnReady" value="LOCK" class="btn_ready_lock"/></td>
 			<td id="display_btn_start"><input type="button" id="btnStart" name="btnStart" value="START" disabled="disabled"/></td>
 			<td><input type="button" id="btnExit" name="btnExit" value="EXIT" isExit="false"/>
 				<input type="hidden" id="isExit" name="isExit" value="false" /></td>
 			<!-- for test -->
 			<!--
 			<td><input type="button" id="btnCheckREHP" name="btnCheckREHP" value="REHP" /></td>
 			<td><input type="button" id="btnCheckRENOHP" name="btnCheckRENOHP" value="RENOHP" /></td>
 			-->
 		</tr>
 		<tr>
 			<td>
				<div style="width:220px">
				<fieldset>
				<legend>Room Player List : </legend>
			 	<div id="div_player_list">
			 		<c:forEach items="${room.players}" var="item">
			   			 ${item.account}<br>
					</c:forEach>
			 	</div>
			 	</fieldset>
			 	</div>
 			</td>
 		</tr>
 		</table>
	</form>
	<form:form id="form_info_update" name="form_info_update" action="room.info.update" method="GET">
		<input type="hidden" id="roomID"      name="roomID"      value="${room.roomID}" />
		<input type="hidden" id="account"     name="account"     value="${me.account}" />
		<input type="hidden" id="boutSec"     name="boutSec"     value="${room.boutSec}" />
		<input type="hidden" id="toStartPass" name="toStartPass" value="" />
		<input type="hidden" id="myState"     name="myState"     value="NONE" />
		<input type="hidden" id="myMap"       name="myMap"       value="" />
		<input type="hidden" id="state"       name="state"       value="${room.state}" />
		<input type="hidden" id="warshipAC"   name="warshipAC"   value="" />
		<input type="hidden" id="warshipAC_D" name="warshipAC_D" value="" />
		<input type="hidden" id="warshipB"    name="warshipB"    value="" />
		<input type="hidden" id="warshipB_D"  name="warshipB_D"  value="" />
		<input type="hidden" id="warshipS"    name="warshipS"    value="" />
		<input type="hidden" id="warshipS_D"  name="warshipS_D"  value="" />
		<input type="hidden" id="warshipD"    name="warshipD"    value="" />
		<input type="hidden" id="warshipD_D"  name="warshipD_D"  value="" />
		<input type="hidden" id="warshipPB"   name="warshipPB"   value="" />
		<input type="hidden" id="warshipPB_D" name="warshipPB_D" value="" />
	</form:form>
	<table>
		<tr>
			<td>
				<table>
				<c:forEach var="item" items="<%=PlayerMap.defaultMap %>" varStatus="tb_y">
					<tr>
				    <c:forEach var="item_i" items="${item}" varStatus="tb_x">
				    	<c:choose>
				    		<c:when test="${tb_y.index eq '0'}">
					    		<td id="${item_i}">&nbsp;${item_i}</td>
				    		</c:when>
				    		<c:when test="${tb_x.index eq '0'}">
					    		<td id="${item_i}">&nbsp;${item_i}</td>
				    		</c:when>
				    		<c:otherwise>
					    		<td id="${item_i}" class="td-blue"><a class="a_blue" href="#" location="${item_i}"><div>&nbsp;</div></a></td>
				    		</c:otherwise>
				    	</c:choose>
					</c:forEach>
				    </tr>
				</c:forEach>
				</table>
			</td>
			<td>
				<table>
					<tr>
						<td id="div_ready_to_start" style="width:155px;valign:middle;align:center;font-size: 50px;color:red;"></td>
					</tr>
					<tr>
						<td align="center">
							<div id="div_open_fire" class="div-fire-N">Open Fire</div>
						</td>
					</tr>
					<tr>
						<td id="div_bout_sec" style="width:155px;valign:middle;align:center;font-size: 50px;" ></td>
					</tr>
				</table>
			</td>
			<td>
				<table>
				<c:forEach var="item" items="<%=PlayerMap.defaultMap %>" varStatus="tb_y">
					<tr>
				    <c:forEach var="item_i" items="${item}" varStatus="tb_x">
				    	<c:choose>
				    		<c:when test="${tb_y.index eq '0'}">
					    		<td id="lx_${item_i}">&nbsp;${item_i}</td>
				    		</c:when>
				    		<c:when test="${tb_x.index eq '0'}">
					    		<td id="lx_${item_i}">&nbsp;${item_i}</td>
				    		</c:when>
				    		<c:otherwise>
					    		<td id="lx_${item_i}" class="td-red"><a class="a_red" href="#" location="${item_i}"><div>&nbsp;</div></a></td>
				    		</c:otherwise>
				    	</c:choose>
					</c:forEach>
				    </tr>
				</c:forEach>
				</table>
			</td>
			<td rowspan="12" valign="top">
				<table>
					<tr>
						<td colspan="7" class="myFleet">My Fleet</td>
					</tr>
					<tr>
						<td>Configuration Warship :</td>
						<td colspan="7">
							<select id="chooseWarship" name="chooseWarship">
								<option value="shipAC">Aircraft Carrier</option>
								<option value="shipB">Battleship</option>
								<option value="shipS">Submarine</option>
								<option value="shipD">Destroyer</option>
								<option value="shipPB">Patrol Boat</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Aircraft Carrier :</td>
						<td>
							<span id="shipAC" name="shipAC" class="div-ship-none" warshipSize="5"/>&nbsp;</span>
							<select id="shipAC_Direction" name="shipAC_Direction">
								<option value="V">V</option>
								<option value="H">H</option>
							</select>
						</td>
						<td id="shipAC_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="shipAC_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="shipAC_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="shipAC_HP4" class="ship_HP_Y">&nbsp;</td>
						<td id="shipAC_HP5" class="ship_HP_Y">&nbsp;</td>
					</tr>
					<tr>
						<td>Battleship :</td>
						<td>
							<span id="shipB" name="shipB" class="div-ship-none" warshipSize="4"/>&nbsp;</span>
							<select id="shipB_Direction" name="shipB_Direction">
								<option value="V">V</option>
								<option value="H">H</option>
							</select>
						</td>
						<td id="shipB_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="shipB_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="shipB_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="shipB_HP4" class="ship_HP_Y">&nbsp;</td>
						<td id="shipB_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
					<tr>
						<td>Submarine :</td>
						<td>
							<span id="shipS" name="shipS" class="div-ship-none" warshipSize="3"/>&nbsp;</span>
							<select id="shipS_Direction" name="shipS_Direction">
								<option value="V">V</option>
								<option value="H">H</option>
							</select>
						</td>
						<td id="shipS_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="shipS_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="shipS_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="shipS_HP4" class="ship_HP_N">&nbsp;</td>
						<td id="shipS_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
					<tr>
						<td>Destroyer :</td>
						<td>
							<span id="shipD" name="shipD" class="div-ship-none" warshipSize="3"/>&nbsp;</span>
							<select id="shipD_Direction" name="shipD_Direction">
								<option value="V">V</option>
								<option value="H">H</option>
							</select>
						</td>
						<td id="shipD_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="shipD_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="shipD_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="shipD_HP4" class="ship_HP_N">&nbsp;</td>
						<td id="shipD_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
					<tr>
						<td>Patrol Boat :</td>
						<td>
							<span id="shipPB" name="shipPB" class="div-ship-none" warshipSize="2"/>&nbsp;</span>
							<select id="shipPB_Direction" name="shipPB_Direction">
								<option value="V">V</option>
								<option value="H">H</option>
							</select>
						</td>
						<td id="shipPB_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="shipPB_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="shipPB_HP3" class="ship_HP_N">&nbsp;</td>
						<td id="shipPB_HP4" class="ship_HP_N">&nbsp;</td>
						<td id="shipPB_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="7" class="enemyFleet">Enemy Fleet</td>
					</tr>
					<tr>
						<td>Aircraft Carrier :</td>
						<td>&nbsp;</td>
						<td id="lx_shipAC_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipAC_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipAC_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipAC_HP4" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipAC_HP5" class="ship_HP_Y">&nbsp;</td>
					</tr>
					<tr>
						<td>Battleship :</td>
						<td>&nbsp;</td>
						<td id="lx_shipB_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipB_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipB_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipB_HP4" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipB_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
					<tr>
						<td>Submarine :</td>
						<td>&nbsp;</td>
						<td id="lx_shipS_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipS_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipS_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipS_HP4" class="ship_HP_N">&nbsp;</td>
						<td id="lx_shipS_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
					<tr>
						<td>Destroyer :</td>
						<td>&nbsp;</td>
						<td id="lx_shipD_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipD_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipD_HP3" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipD_HP4" class="ship_HP_N">&nbsp;</td>
						<td id="lx_shipD_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
					<tr>
						<td>Patrol Boat :</td>
						<td>&nbsp;</td>
						<td id="lx_shipPB_HP1" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipPB_HP2" class="ship_HP_Y">&nbsp;</td>
						<td id="lx_shipPB_HP3" class="ship_HP_N">&nbsp;</td>
						<td id="lx_shipPB_HP4" class="ship_HP_N">&nbsp;</td>
						<td id="lx_shipPB_HP5" class="ship_HP_N">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div class="war_history_table">
		<div>
			<label class="td_title history_l">Location</label>
			<label class="td_title history_w">Warship</label>
			<label class="td_title history_m">Message</label>
		</div>
		<div id="war_history">
		
		</div>
	</div>
</body>
</html>
; Tested on and developed for Linux with AHK_X11. Probably compatible with Windows too.

; To use, set var activity_monitor_logfile, #Include this script and call `GoSub, run_activity_monitor` (this does never finish)

Return

run_activity_monitor:
	if activity_monitor_logfile =
	{
		msgbox variable activity_monitor_logfile needs to be set
		exitapp 1
	}

	Hotkey, ~^x up, activity_monitor_clipboard_store
	Hotkey, ~^c up, activity_monitor_clipboard_store
	Hotkey, ~^!c up, activity_monitor_clipboard_store
	Hotkey, ~^+c up, activity_monitor_clipboard_store

	settimer, activity_monitor_minute_ticker, 60000

	loop
	{
		input, input, v i t30 l1000
		if input <>
			fileappend, %a_now%`;TYPE`;%input%`n, %activity_monitor_logfile%
	}
Return

activity_monitor_clipboard_store:
	settimer, activity_monitor_new_clipboard, 1000 ; debounce
	return
	activity_monitor_new_clipboard:
	settimer, activity_monitor_new_clipboard, off
	clp = %clipboard%
	if clp = ; picture, file, ..
		return
	stringmid, clp, clp, 1, 3500
	stringreplace, clp, clp, `n, ``n, all
	stringreplace, clp, clp, `;, ```;, all
	
	if clp = %activity_monitor_last_clipboard%
		return
	activity_monitor_last_clipboard = %clp%
	fileappend, %a_now%`;CLIPBOARD`;%clp%`n, %activity_monitor_logfile%
	clp =
return

activity_monitor_minute_ticker:
	wingettext, txt, A
	wingettitle, title, A
	stringreplace, title, title, `;, ```;, all
	stringmid, txt, txt, 1, 5000
	stringreplace, txt, txt, `n, ``n, all
	stringreplace, txt, txt, `;, ```;, all
	if txt = %activity_monitor_last_win_txt%
		return
	activity_monitor_last_win_txt = %txt%
	fileappend, %a_now%`;WINDOW`;%title%`;%txt%`n, %activity_monitor_logfile%
	txt =
return
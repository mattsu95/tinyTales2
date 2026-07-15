var _type = async_load[? "type"];

if (_type == "video_end") { // se o video acabou
    video_close();		// limpa o vídeo da memória
    room_goto(Menu);	// avança para a fase após a intro
}
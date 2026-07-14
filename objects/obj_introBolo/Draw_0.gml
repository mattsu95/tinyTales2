var _videoData = video_draw(); // processa o video
var _videoStatus = _videoData[0];

if (_videoStatus == 0) // rodando sem erro
{
	// desenha a superfície que capturou o frame atual do vídeo
	draw_surface(_videoData[1], 0, 0);
}
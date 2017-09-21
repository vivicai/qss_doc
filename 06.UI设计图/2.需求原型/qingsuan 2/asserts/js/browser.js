$(function(){

	var temp = '';
	temp += '<div class="browser-tips">';
	temp += '<p> 本页面采用HTML5+CSS3，您正在使用老版本 Internet Explorer ，在本页面的显示效果可能有差异。建议您升级到 Internet Explorer 9 以上或者Chrome、firefox、Safari浏览器。</p>';
    temp += '<div class="browser-action">';
    temp += '<a class="btn" href="#">';
    temp += '<span class="current-font">不再提示</span>';
    temp += '</a>';
    temp += '<i class="fa fa-close"></i>';
    temp += '</div>';
	temp += '</div>';

	var browserFlag = $.cookie("browserFlag");
	if(browserFlag != 1){
		$("body").prepend(temp);
	}
	
	$(".browser-tips .fa-close").click(function(){
		$(".browser-tips").hide();
	});

	$(".browser-action .btn").click(function(){
		$(".browser-tips").hide();
		$.cookie("browserFlag",1);
	})
});


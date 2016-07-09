$(document).ready(
    function () {
        console.log($.deserialize(window.location.search));
    }
);

function changeContents (url) {
    $('#contents').val('src', url);
}
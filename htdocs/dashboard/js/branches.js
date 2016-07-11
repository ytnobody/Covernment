$(document).ready(function(){
    var project = location.paramObject.project;
    setProjectName(project);
    loadBranches(project);
});

function setProjectName (projectName) {
    $('.projectName').text(projectName);
}

function loadBranches (projectName) {
    $.get('/api/v1/project/' + projectName + '/branches', function(json){
        $.each(json.branches, function(i, branch) {
            var p = '<h2>'+ branch +'</h2><ul class="'+ branch +' commits"></ul>';
            $('.branches').append(p);
            loadCommits(projectName, branch);
        });
    });
}

function loadCommits (project, branch) {
    $.get('/api/v1/project/' + project + '/' + branch + '/commits', function(json){
        $.each(json.commits, function(i, commit) {
            var p = '<li><a href="/project/'+ project +'/'+ branch +'/'+ commit +'/cover_db/coverage.html">'+ commit +'</a></li>';
            $('.commits.' + branch).append(p);
        });
    });
}
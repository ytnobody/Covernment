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
            var p = '<h2>'+ branch +'</h2><table class="table table-bordered '+ branch +' commits"></table>';
            $('.branches').append(p);

            var th = $('<tr><th>Commit</th><th>Date</th></tr>');
            $('.commits.' + branch).append(th);
            loadCommits(projectName, branch);
        });
    });
}

function loadCommits (project, branch) {
    $.get('/api/v1/project/' + project + '/' + branch + '/commits', function(json){
        $.each(json.commits, function(i, commit) {
            var p = $('<tr></tr>');
            p.append('<td><a href="/project/'+ project +'/'+ branch +'/'+ commit.id +'/cover_db/coverage.html">'+ commit.id +'</a></td>');
            p.append('<td>'+ commit.date +'</td>');
            $('.commits.' + branch).append(p);
        });
    });
}

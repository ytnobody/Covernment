$(document).ready(function () { 
    loadProjects();
    var action = location.paramObject.action ? location.paramObject.action : 'default';
    var actionMethod = new Function('return action_' + action + '()');
    actionMethod();
});

function loadProjects () {
    $.get('/api/v1/projects', function(json){
        $.each(json.projects, function(i, project) {
            var p = $('<li><a href="/dashboard/index.html?action=branches&project='+ project +'">'+ project +'</a></li>');
            $('ul#projects').append(p);
        });
    });
}

function action_default () {
    document.contents.location.href = '/dashboard/commits.html'; 
}

function action_branches () {
    var project = location.paramObject.project;
    document.contents.location.href = '/dashboard/branches.html?project=' + project; 
}
$(document).ready(function(){
    $.get('/api/v1/commits', function(json){
        $.each(json.commits, function(i, row){
            var p = $('<tr></tr>');
            p.append('<td><a href="/dashboard/branches.html?action=branches&project='+ row.project +'">'+ row.project +'</a></td>');
            p.append('<td>'+ row.branch +'</td>');
            p.append('<td><a href="/project/'+ row.project+'/'+ row.branch +'/'+ row.commit +'/cover_db/coverage.html">'+ row.commit +'</a></td>');
            p.append('<td>'+ row.date +'</td>')
            $('.commits').append(p);
        });
    });
});
$(document).ready(function() {
    $('#user-list').DataTable( {
        responsive: true,
        fixedHeader: true,
        order: [[ 1, "asc"]],
        stateSave: true,
        columnDefs: [
            { type: 'dateNonStandard', targets: [
                7
                ]
            }
        ]
    })
});
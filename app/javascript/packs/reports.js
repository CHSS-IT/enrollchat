$(document).ready(function() {
  $('#report').DataTable( {
    ressponsive: true,
    fixedHeader: true,
    columnDefs: [
      { sortable: false, targets: [
          12
        ]
      }
    ]
  })
});

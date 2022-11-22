$(document).ready(function() {
    $('.spinner').hide();
});

$(document).ready(function() {
    $("#update-form").on("submit", (e, data, status, xhr) => $("#upload-sections").trigger('click'));
    $("#update-form").on("ajax:beforeSend", (e, data, status, xhr) => $('.spinner').show());
    $("#update-form").on("ajax:complete", (e, data, status, xhr) => $('.spinner').hide());

    $('#upload-sections').on('click', function() {
        $(this).toggleClass('unique-color grey');
    });
    $('#update-form').on('submit', function() {
        $('#upload-sections').attr('class', 'btn unique-color');
        $('#uploadSupportedContent').addClass('collapse');
    });
    $('input:file').change(function() {
        if ($(this).val()) {
            $('button:submit').removeAttr('disabled');
        }
    });
});

$(document).ready(function() {
    $('#filter-submit').click(function() {
        $(this).parents('form').submit();
    })
});

$(document).ready(function() {
    $.fn.dataTable.moment( 'MMMM D, YYYY' );

    jQuery.extend(jQuery.fn.dataTableExt.oSort, {
            'dateNonStandard-asc'(a, b) {
                const x = Date.parse(a);
                const y = Date.parse(b);
                if (x === y) {
                    return 0;
                }
                if (isNaN(x) || (x < y)) {
                    return 1;
                }
                if (isNaN(y) || (x > y)) {
                    return -1;
                }
            },
            'dateNonStandard-desc'(a, b) {
                const x = Date.parse(a);
                const y = Date.parse(b);
                if (x === y) {
                    return 0;
                }
                if (isNaN(y) || (x < y)) {
                    return -1;
                }
                if (isNaN(x) || (x > y)) {
                    return 1;
                }
            }
        }
    );
});

$(document).ready(function() {
    table = $('#class-sections').DataTable( {
        responsive: true,
        fixedHeader: true,
        order: [[ 4, "asc" ]],
        buttons: [ 'print', 'excel', 'pdf' ],
        columnDefs: [
            { type: 'dateNonStandard', targets: [
                    15
                ]
            },
            { sortable: false, targets: [
                    0
                ]
            },
            { responsivePriority: 1, targets: [
                    4,
                    !$('body').hasClass('sections') || !$('body').hasClass('show') ? 17 : undefined,
                    !$('body').hasClass('sections') || !$('body').hasClass('show') ? 18 : undefined
                ]
            },
            { responsivePriority: 2, targets: [
                    0
                ]
            },
            { responsivePriority: 3, targets: [
                    5,
                    9,
                    12
                ]

            },
            { responsivePriority: 4, targets: [
                    6,
                    7,
                    8,
                    10,
                    11,
                    13,
                    14
                ]
            }
        ],
        stateSave: true
    });
    table.buttons().container().appendTo($('.col-md-6:eq(0)', table.table().container()))
});

$(document).ready(function() {
    $('body').popover({
        selector: '[data-toggle="popover"]', trigger: 'hover'
    });
});
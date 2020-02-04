import consumer from "./consumer"

consumer.subscriptions.create({ channel: "DepartmentChannel" }, {
    received(data) {
        $('#notifications').prepend(data.message);
        if ($('#alerts-button').hasClass('unique-color-dark')) {
            $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong');
        }
        $('button#alerts-button').effect("pulsate", {times:2}, 1000);
        const dom_id = '#section_' + data.section_id + ' td a span.comment-count';
        $(dom_id).html(data.comment_count);
    }
});
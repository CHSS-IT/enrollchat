import consumer from "channels/consumer"

consumer.subscriptions.create({ channel: "RoomChannel" }, {
    received(data) {
        if (data.trigger === 'Updated') {
            location.reload();
        }
        let dom_id = '#section_' + data.section_id + ' td a span.comment-count';
        $(dom_id).html(data.comment_count);
        if (data.trigger === 'Refresh') {
            dom_id = '#section_' + data.section_id + ' td .comment-hover';
            $(dom_id).attr('data-content', data.body);
            dom_id = '#section_' + data.section_id + ' td .comment-hover';
            $(dom_id).attr('data-title', 'New comment by ' + data.user);
            dom_id = '#section_' + data.section_id + ' td .comment-hover';
            $(dom_id).attr('data-original-title', 'New comment by ' + data.user);
        }
        if (data.trigger === 'Remove') {
            if (data.comment_count === 0) {
                dom_id = '#section_' + data.section_id + ' td #preview-comment';
                if ($(dom_id).hasClass('fa fa-info-circle')) {
                    $(dom_id).removeClass('fa fa-info-circle');
                }
            }
        }
    }
});
import consumer from "channels/consumer"

consumer.subscriptions.create({ channel: "RoomChannel" }, {
    received(data) {
        if (data.trigger === 'Updated') {
            location.reload();
        }
    }
});
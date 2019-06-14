HAMDLERS = {
      "start": 'start',
      "English": 'set_client_english',
      "Русский": 'set_client_russian',
      "правилами": 'client_sign',
      "About": 'client_about',
      "Wallet": 'client_menu',
      "Settings": 'client_settings',
      "Cancel": 'cancel',
      "Кошелек": 'client_menu',
      "Настройки": 'client_settings',
      "проекте": 'client_about',
      "Продать": 'buy_amount',
      "Купить": 'client_buy'
}

ENDPOINTS = %w(
        getUpdates setWebhook deleteWebhook getWebhookInfo getMe sendMessage
        forwardMessage sendPhoto sendAudio sendDocument sendSticker sendVideo
        sendVoice sendLocation sendVenue sendContact sendChatAction
        getUserProfilePhotos getFile kickChatMember leaveChat unbanChatMember
        getChat getChatAdministrators getChatMembersCount getChatMember
        answerCallbackQuery editMessageText editMessageCaption
        editMessageReplyMarkup answerInlineQuery sendGame setGameScore
        getGameHighScores deleteMessage
      ).freeze
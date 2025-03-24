//
//  IntentService.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 24/03/25.
//

import Foundation
import Intents

protocol IntentServiceProtocol: AnyObject {
    func donateIntent(userID: String, name: String)
}

class IntentService: IntentServiceProtocol {
    init() {}

    func donateIntent(userID: String, name: String) {
        let groupName = INSpeakableString(spokenPhrase: "Juan Chavez")
        let sendMessageIntent = INSendMessageIntent(
            recipients: nil,
            outgoingMessageType: .unknown,
            content: nil,
            speakableGroupName: groupName,
            conversationIdentifier: "sampleConversationIdentifier",
            serviceName: nil,
            sender: nil,
            attachments: []
        )

        let image = INImage(named: "person")
        sendMessageIntent.setImage(image, forParameterNamed: \.speakableGroupName)


        let interaction = INInteraction(intent: sendMessageIntent, response: nil)
        interaction.donate(completion: { error in
            if let error = error {
                print("Error donating intent: \(error)")
            } else {
                print("Successfully donated sendMessage intent.")
            }
        })
    }
}


/**let person = INPerson(
 personHandle: INPersonHandle(value: userID, type: .unknown),
 nameComponents: nil,
 displayName: name,
 image: nil,
 contactIdentifier: nil,
 customIdentifier: userID
 )

 let name = INSpeakableString(spokenPhrase: name)

 let intent = INSendMessageIntent(
 recipients: [person],
 outgoingMessageType: .unknown,
 content: nil,
 speakableGroupName: name,
 conversationIdentifier: userID,
 serviceName: nil,
 sender: nil,
 attachments: []
 )

 intent.setImage(INImage(named: "person"), forParameterNamed: \.recipients)
 intent.suggestedInvocationPhrase = "Share to \(name)"

 let interaction = INInteraction(intent: intent, response: nil)
 interaction.donate { error in
 if let error = error {
 print("Intent donation failed: \(error)")
 } else {
 print("Intent donated for \(name)")
 }
 }*/

/**
 func generateRecipient(conversationIdentifier:String, displayName:String, img:String) {
 //        Create an INSendMessageIntent to donate an intent for a conversation
 //        let conversationID = self.conversationIdentifier?.uuidString

 let conversationID = conversationIdentifier
 let groupName = INSpeakableString(spokenPhrase: displayName)
 //         Add the user's avatar to the intent.
 let image = INImage(named: "image133")

 let sendMessageIntent = INSendMessageIntent(recipients: nil,
 content: nil,
 speakableGroupName: groupName,
 conversationIdentifier: conversationID,
 serviceName: nil,
 sender: nil)

 sendMessageIntent.setImage(image, forParameterNamed: \.speakableGroupName)

 //         Donate the intent.
 let interaction = INInteraction(intent: sendMessageIntent, response: nil)
 interaction.donate(completion: { error in
 if error != nil {
 //                 Add error handling here.
 } else {
 //                 Do something, for example, send the content to a contact.
 print("INSendMessageIntent has been donated Successfully!!")
 }
 })
 }

 */

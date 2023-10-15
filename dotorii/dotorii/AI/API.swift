//
//  API.swift
//  FinSight
//
//  Created by Asif Islam on 9/17/23.
//

import AVFoundation
import LangChain
import Foundation
import OpenAI

class LLM_API {
    private var speechSynthesizer = AVSpeechSynthesizer()
    var ai = OpenAI(apiToken: "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")
    
    func runQuery(poster: String) -> String {
        let q = "Extract who wants which items with their quantity in JSON format."
        
        let prompt = poster + q
        let maxTokens = 100
        var generatedText = ""

        let query = CompletionsQuery(model: .textDavinci_003, prompt: prompt, temperature: 0, maxTokens: maxTokens, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        ai.completions(query: query) { result in
            switch result {
                case .success(let completionsResult):
                    guard let firstChoiceText = completionsResult.choices.first?.text else {
                        print("No choices available")
                        return
                    }
                    print(firstChoiceText)
                    generatedText = firstChoiceText
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
        }
        
        return(generatedText)
    }
    

    func analyzeReceipt(receipt_data:String) -> String {
        var output = ""
        
        let template = 
        """
        Based on this information create a json fie to create an event with the google calendar API. 
        Only return the code without any additional lines.

        %@
        Human: %@
        Assistant:
        """

        let prompt = PromptTemplate(input_variables: ["history", "human_input"], template: template)
        
        let chatgpt_chain = LLMChain(
            llm: OpenAI(),
            prompt: prompt,
            parser: StrOutputParser(),
            memory: ConversationBufferWindowMemory()
        )
        
        Task {
            var input = ["human_input": receipt_data]
            var output = await chatgpt_chain.predict(args: input)
            print(output["Answer"]!)
//            print("FINISHED ANALYZING RECEIPT")
//            let utterance = AVSpeechUtterance(string: output["Answer"]!)
//            utterance.pitchMultiplier = 1.0
//            utterance.rate = 0.5
//            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//
//            speechSynthesizer.speak(utterance)
//            print("did you hear me?")

            return output["Answer"]!
        }

//        let jsonData = output.data(using: .utf8)
//
//        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let jsonFileURL = documentDirectory.appendingPathComponent("output.json")
//    
//            do {
//                try jsonData?.write(to: jsonFileURL)
//                print("JSON data has been saved to \(jsonFileURL.path)")
//            } catch {
//                print("Error writing JSON data to file: \(error)")
//            }
//        }
        
        return output
    }
}

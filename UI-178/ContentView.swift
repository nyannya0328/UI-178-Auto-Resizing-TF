//
//  ContentView.swift
//  UI-178
//
//  Created by にゃんにゃん丸 on 2021/05/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View{
    @State var text = ""
    @State var containerHeight : CGFloat = 0
    
    var body: some View{
        
        
        NavigationView{
            
            VStack{
                
                AutosizingTF(hint: "Enter", text: $text, containerHeight: $containerHeight, onend: {
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    
                })
                    .padding(.horizontal)
                    .frame(height: containerHeight <= 150 ? containerHeight : 150)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding()
                .shadow(color: .primary.opacity(0.3), radius: 5, x: 5, y: 5)
                .shadow(color: .white.opacity(0.3), radius: 5, x: -10, y: -10)
            }
            
            .navigationBarTitle("Input Accessroy View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.05).ignoresSafeArea()
            
                            .onTapGesture {
                                UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
                            }
            
            )
            
        }
    }
}

struct AutosizingTF : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return AutosizingTF.Coordinator(parent: self)
    }
    
    
    var hint : String
    @Binding var text : String
    @Binding var containerHeight : CGFloat
    var onend : ()->()
    func makeUIView(context: Context) -> UITextView {
        
        let view = UITextView()
        view.text = hint
        view.textColor = .black
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 25)
        view.delegate = context.coordinator
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        toolBar.barStyle = .default
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.closekeyBorad))
        
        toolBar.items = [spacer,doneButton]
        toolBar.sizeToFit()
        
        view.inputAccessoryView = toolBar
        
        return view
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        
        DispatchQueue.main.async {
            if containerHeight == 0{
                
                
                containerHeight = uiView.contentSize.height
                
            }
            
        }
        
    }
    
    class Coordinator : NSObject,UITextViewDelegate{
        var parent : AutosizingTF
        
        init(parent : AutosizingTF) {
            self.parent = parent
        }
        
        
        @objc func closekeyBorad(){
            
            parent.onend()
            
            
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text ==  parent.hint{
                textView.text = ""
                textView.textColor = UIColor(Color.green)
                
                
            }
            
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            parent.text = textView.text
            
            parent.containerHeight = textView.contentSize.height
            
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if textView.text == ""{
                
                textView.text = parent.text
                textView.textColor = .red
                
            }
            
        }
        
        
    }
}

import SwiftUI

struct CommentItemView: View {
    var comment: Comment
    
    let homeBeerYellow: Color = Color(red: 249 / 255, green: 208 / 255, blue: 148 / 255)
    let homeBeerBrown: Color = Color(red: 46 / 255, green: 42 / 255, blue: 36 / 255)
    
    var body: some View {
        HStack {
            VStack {
                Text(comment.text)
                    .foregroundColor(homeBeerYellow)
                    .background(homeBeerBrown)
                    .cornerRadius(16)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom, 8)
                Text(getDaysAgo(commentDate: comment.date))
                    .foregroundColor(homeBeerYellow)
                    .background(homeBeerBrown)
                    .cornerRadius(16)
                    .fontWeight(.heavy)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, 8)
            }.background(homeBeerBrown)
                .frame(alignment: .topTrailing)
                .cornerRadius(16)
        }.cornerRadius(16)
            .frame(width: 320)
    }
    
    func getDaysAgo(commentDate: Date) -> String {
        var daysAgo = String(format: "%.0f", Date.now.timeIntervalSince(comment.date) / 60 / 60 / 24)
        
        if((Date.now.timeIntervalSince(comment.date) / 60 / 60 / 24).rounded() > 1) {
                daysAgo = daysAgo + " dias atrás"
        } else {
            if((Date.now.timeIntervalSince(comment.date) / 60 / 60 / 24).rounded() > 0) {
                daysAgo = daysAgo + " dia atrás"
            } else {
                daysAgo = "Hoje"
            }
        }
        
        return daysAgo
   }
                       
}

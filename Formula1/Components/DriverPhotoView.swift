import SwiftUI
import Kingfisher

struct DriverPhotoView: View {
    let driverName: String
    let teamColor: Color
    let size: CGFloat
    let driverCode: String?

    init(driverName: String, teamColor: Color = .f1Accent, size: CGFloat = 60, driverCode: String? = nil) {
        self.driverName = driverName
        self.teamColor = teamColor
        self.size = size
        self.driverCode = driverCode
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(teamColor.opacity(0.2))
                .frame(width: size, height: size)

            Circle()
                .stroke(teamColor, lineWidth: 2)
                .frame(width: size, height: size)

            if driverCode != nil, !driverCode!.isEmpty {
                KFImage(F1Media.driverPhotoURL(driverName: driverName))
                    .placeholder { _ in initialsView }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size - 4, height: size - 4)
                    .clipShape(Circle())
            } else {
                initialsView
            }
        }
    }

    private var initialsView: some View {
        Text(initials)
            .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
            .foregroundColor(teamColor)
    }

    private var initials: String {
        let parts = driverName.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.dropFirst().first?.prefix(1) ?? ""
        return "\(first)\(last)".uppercased()
    }
}

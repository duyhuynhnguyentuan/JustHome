//
//  ContractProgressView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/11/24.
//

import SwiftUI
import StepperView

struct ContractProgressView: View {
    let updatedTime: String
    let contractStatus: ContractsStatus
    let steps = [
        Text("Chờ xác nhận TTDG").font(.system(.body, design: .rounded)),
        Text("Chờ xác nhận TTĐC").font(.system(.body, design: .rounded)),
        Text("Đã xác nhận TTĐC").font(.system(.body, design: .rounded)),
        Text("Đã xác nhận chính sách bán hàng").font(.system(.body, design: .rounded)),
        Text("Đã xác nhận phiếu tính giá").font(.system(.body, design: .rounded)),
        Text("Đã thanh toán đợt 1 hợp đồng mua bán").font(.system(.body, design: .rounded)),
        Text("Đã xác nhận hợp đồng mua bán").font(.system(.body, design: .rounded)),
        Text("Đã bàn giao quyền sở hữu đất").font(.system(.body, design: .rounded))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tiến độ hợp đồng")
                .font(.title.bold())
            Text(getUpdatedTime())
                .italic()
                .font(.caption.bold())
                .foregroundStyle(.red)
            Text(updatedTime)
                .italic()
                .font(.callout.bold())
                .foregroundStyle(.red)
            StepperView()
                .addSteps(steps)
                .indicators(getIndicators())
                .stepIndicatorMode(StepperMode.vertical)
                .lineOptions(StepperLineOptions.rounded(4, 8, Color(red: 116, green: 204, blue: 177), .systemGray))
                .stepLifeCycles(getStepLifeCycles())
                .spacing(30)
            Spacer()
        }
        .padding(.top)
    }
    
    private func getUpdatedTime() -> String {
        switch contractStatus {
        case .choxacnhanTTDG:
            "Đang chờ xác nhận thỏa thuận giao dịch"
        case .choxacnhanTTDC:
            "Đã xác nhận thỏa thuận giao dịch vào:"
        case .daxacnhanTTDC:
            "Đã xác nhận thỏa thuận đặt cọc vào:"
        case .daxacnhanchinhsachbanhang:
            "Đã xác nhận chính sách bán hàng vào:"
        case .daxacnhanphieutinhgia:
            "Đã xác nhận phiếu tính giá vào:"
        case .dathanhtoandot1hopdongmuaban:
            "Đã thanh toán đợt 1 hợp đồng mua bán vào:"
        case .daxacnhanhopdongmuaban:
            "Đã xác nhận hợp đồng mua bán vào:"
        case .dabangiaoquyensohuudat:
            "Đã xác nhận bàn giao quyền sở hữu dất vào:"
        case .choxacnhanTTCN:
            "Đang chờ xác nhận thỏa thuận chuyển nhượng"
        case .daxacnhanchuyennhuong:
            "Đã xác nhận thỏa thuận chuyển nhượng vào:"
        case .choxacnhanTTCNTTDC:
            "Đang chờ xác nhận thỏa thuận chuyển nhượng thỏa thuận đặt cọc"
        case .dahuy:
            "Đã hủy"
        }
    }
    private func getIndicators() -> [StepperIndicationType<IndicatorImageView>] {
        let completed = StepperIndicationType.custom(IndicatorImageView(name: "completed"))
        let pending = StepperIndicationType.custom(IndicatorImageView(name: "pending"))
        
        switch contractStatus {
        case .choxacnhanTTDG:
            return [pending, pending, pending, pending, pending, pending, pending, pending]
        case .choxacnhanTTDC:
            return [completed, pending, pending, pending, pending, pending, pending, pending]
        case .daxacnhanTTDC:
            return [completed, completed, completed, pending, pending, pending, pending, pending]
        case .daxacnhanchinhsachbanhang:
            return [completed, completed, completed, completed, pending, pending, pending, pending]
        case .daxacnhanphieutinhgia:
            return [completed, completed, completed, completed, completed, pending, pending, pending]
        case .dathanhtoandot1hopdongmuaban:
            return [completed, completed, completed, completed, completed, completed, pending, pending]
        case .daxacnhanhopdongmuaban:
            return [completed, completed, completed, completed, completed, completed, completed, pending]
        case .dabangiaoquyensohuudat:
            return [completed, completed, completed, completed, completed, completed, completed, completed]
        default:
            return [completed, completed, completed, completed, completed, completed, completed, completed]
        }
    }
    
    private func getStepLifeCycles() -> [StepLifeCycle] {
        switch contractStatus {
        case .choxacnhanTTDG:
            return [.pending, .pending, .pending, .pending, .pending, .pending, .pending, .pending]
        case .choxacnhanTTDC:
            return [.completed, .pending, .pending, .pending, .pending, .pending, .pending, .pending]
        case .daxacnhanTTDC:
            return [.completed, .completed, .completed, .pending, .pending, .pending, .pending, .pending]
        case .daxacnhanchinhsachbanhang:
            return [.completed, .completed, .completed, .completed, .pending, .pending, .pending, .pending]
        case .daxacnhanphieutinhgia:
            return [.completed, .completed, .completed, .completed, .completed, .pending, .pending, .pending]
        case .dathanhtoandot1hopdongmuaban:
            return [.completed, .completed, .completed, .completed, .completed, .completed, .pending, .pending]
        case .daxacnhanhopdongmuaban:
            return [.completed, .completed, .completed, .completed, .completed, .completed, .completed, .pending]
        case .dabangiaoquyensohuudat:
            return [.completed, .completed, .completed, .completed, .completed, .completed, .completed, .pending]
        default:
            return [.completed, .completed, .completed, .completed, .completed, .completed, .completed, .completed]
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct IndicatorImageView: View {
    var name: String
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.white)
                .overlay(Image(name)
                    .resizable()
                    .frame(width: 30, height: 30))
                .frame(width: 40, height: 40)
        }
    }
}

//#Preview {
//    ContractProgressView(contractStatus: .choxacnhanTTDG)
//}


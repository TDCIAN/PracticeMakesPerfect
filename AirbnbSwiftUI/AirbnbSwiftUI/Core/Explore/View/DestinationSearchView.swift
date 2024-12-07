//
//  DestinationSearchView.swift
//  AirbnbSwiftUI
//
//  Created by 김정민 on 10/16/24.
//

import SwiftUI

enum DestinationSearchOptions {
    case location
    case dates
    case guests
}

struct DestinationSearchView: View {
    
    @Binding var show: Bool
    @ObservedObject var viewModel: ExploreViewModel

    @State private var selectedOption: DestinationSearchOptions = .location
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var numGuests: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.viewModel.updateListingsForLocation()
                    self.show.toggle()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                })
                
                Spacer()
               
                if !self.viewModel.searchLocation.isEmpty {
                    Button(action: {
                        self.viewModel.searchLocation.removeAll()
                        self.viewModel.updateListingsForLocation()
                    }, label: {
                        Text("Clear")
                    })
                    .foregroundStyle(.black)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                if self.selectedOption == .location {
                    Text("Where to?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        
                        TextField("Search destinations", text: self.$viewModel.searchLocation)
                            .font(.subheadline)
                            .onSubmit {
                                self.viewModel.updateListingsForLocation()
                                self.show.toggle()
                            }
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(Color(.systemGray4))
                    }
                } else {
                    CollapsedPickerView(title: "Where", description: "Add destination")
                }
            }
            .modifier(CollapsableDestinationViewModifier())
            .frame(height: self.selectedOption == .location ? 120 : 64)
            .onTapGesture {
                withAnimation(.snappy) {
                    self.selectedOption = .location
                }
            }
            
            // date selection view
            VStack(alignment: .leading) {
                if self.selectedOption == .dates {
                    Text("When is your trip?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack {
                        DatePicker("From", selection: self.$startDate, displayedComponents: .date)
                        
                        Divider()
                        
                        DatePicker("To", selection: self.$endDate, displayedComponents: .date)
                    }
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                } else {
                    CollapsedPickerView(title: "When", description: "Add dates")
                }
            }
            .modifier(CollapsableDestinationViewModifier())
            .frame(height: self.selectedOption == .dates ? 180 : 64)
            .onTapGesture {
                withAnimation(.snappy) {
                    self.selectedOption = .dates
                }
            }
            
            // num guests view
            VStack(alignment: .leading) {
                if self.selectedOption == .guests {
                    Text("Who's coming")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Stepper(
                        label: {
                            Text("\(self.numGuests) Adults")
                        },
                        onIncrement: {
                            print("Add 1")
                            self.numGuests += 1
                        },
                        onDecrement: {
                            print("Subtract 1")
                            guard self.numGuests > 0 else { return }
                            self.numGuests -= 1
                        }
                    )
                } else {
                    CollapsedPickerView(title: "Who", description: "Add guests")
                }
            }
            .modifier(CollapsableDestinationViewModifier())
            .frame(height: self.selectedOption == .guests ? 120 : 64)
            .onTapGesture {
                withAnimation(.snappy) {
                    self.selectedOption = .guests
                }
            }
            
            Spacer()
        }
    }
}

struct CollapsableDestinationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(radius: 10)
    }
}

struct CollapsedPickerView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            HStack {
                Text(self.title)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text(self.description)
            }
            .fontWeight(.semibold)
            .font(.subheadline)
        }
    }
}

#Preview {
    DestinationSearchView(show: .constant(false), viewModel: ExploreViewModel(service: ExploreService()))
}

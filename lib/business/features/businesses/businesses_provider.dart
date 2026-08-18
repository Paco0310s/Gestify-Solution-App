import 'package:gestify_solution/business/features/businesses/models/business_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'businesses_provider.g.dart';

@riverpod
Future<List<BusinessModel>> businessesList(Ref ref) async {
  // Simulate fetching data from an API or database
  await Future.delayed(Duration(seconds: 2));
  return [
    BusinessModel(id: '1', name: 'Business One', description: 'Description for Business One', rfc: 'RFC123456'),
    BusinessModel(id: '2', name: 'Business Two', description: 'Description for Business Two', rfc: 'RFC654321'),
    // Add more businesses as needed
  ];
}

// @riverpod
// class BusinessesList extends _$BusinessesList {
//   @override
//   List<BusinessModel> build() {
//     return [];
//   }

//   Future<void> fetchBusinesses() async {
//     // Simulate fetching data from an API or database
//     await Future.delayed(Duration(seconds: 2));
//     state = [
//       BusinessModel(id: '1', name: 'Business One', description: 'Description for Business One', rfc: 'RFC123456'),
//       BusinessModel(id: '2', name: 'Business Two', description: 'Description for Business Two', rfc: 'RFC654321'),
//       // Add more businesses as needed
//     ];
//   }

//   void addBusiness(BusinessModel business) {
//     state = [...state, business];
//   }

//   void removeBusiness(String id) {
//     state = state.where((business) => business.id != id).toList();
//   }

//   void updateBusiness(BusinessModel updatedBusiness) {
//     state = state.map((business) {
//       if (business.id == updatedBusiness.id) {
//         return updatedBusiness;
//       }
//       return business;
//     }).toList();
//   }
// }

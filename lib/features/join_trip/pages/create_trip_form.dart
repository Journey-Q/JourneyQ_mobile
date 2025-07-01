import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';

class CreateTripForm extends StatelessWidget {
  const CreateTripForm({super.key});

  @override
  Widget build(BuildContext context) {
    return TripFormWidget(
      mode: TripFormMode.create,
      onSubmit: (formData) {
        // Add the new trip to data
        SampleData.createdTripForms.add(formData);
      },
    );
  }
}
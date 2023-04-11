import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();

}

class _EditProfileState extends ConsumerState<EditProfile> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _proprietorController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/16168011/pexels-photo-16168011.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
            ),
            const SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: const Text('Edit Avatar / Profile pic')),
            const SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: 'Comapny',
                      suffixText: '*'
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Company Cannot Be Empty';
                      }
                      return 'Valid';
                    },

                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    
                    controller: _proprietorController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: 'proprietor',
                      suffixText: '*'
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'proprietor Cannot Be Empty';
                      }
                      return 'Valid';
                    },

                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: 'Location',
                      suffixText: '*'
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Location Cannot Be Empty';
                      }
                      return 'Valid';
                    },

                  ),

                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      FilledButton(
                    onPressed: (){}, 
                    child: const Text('Update', style: TextStyle(fontSize: 15),), 
                    ),
                    ],
                  )

                ],
              ),
            )
          ],
        ),
      )
      ),
    ),
    );
  }
  
}
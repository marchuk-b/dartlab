import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/helper/filters.dart';
import 'package:photo_editor/model/filter.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Filter currentFilter;
  late List<Filter> filters;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        // title: Text("Filters"),
        actions: [
          IconButton(
            onPressed: () async{
              Uint8List? bytes = await screenshotController.capture();
              imageProvider.changeImage(bytes!);
              if(!mounted) return;
              Navigator.of(context).pop();  
            }, 
            icon: const Icon(Icons.done)
          )
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              return Screenshot(
                controller: screenshotController,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(currentFilter.matrix),
                  child: Image.memory(value.currentImage!),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 110,
        color: AppColors.bottomBarColor,
        child: SafeArea(
          child: Consumer<AppImageProvider>(
            builder:(BuildContext context, value, Widget? child){
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (BuildContext context, int index) {
                  Filter filter = filters[index];
                  return Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10), 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  currentFilter = filter;
                                });
                              },
                              child: Column(
                                children: [
                                  ColorFiltered(
                                    colorFilter: ColorFilter.matrix(filter.matrix),
                                    child: Image.memory(value.currentImage!),
                                  )
                                ],
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          filter.filterName, 
                          style: const TextStyle(
                            color: AppColors.textPrimary
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ),
      ),
    );
  }
}
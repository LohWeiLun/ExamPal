import 'package:flutter/material.dart';

class FastNoteBackupFunctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Note Backup'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fastnoteback.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Files",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.asset('assets/icons/pdf.png'),
                            title: Text(
                              "Filename",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "Path To File",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: ((context, index) => Divider(
                          color: Colors.white,
                        )),
                        itemCount: 3,
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Functions",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    child: Row(
                                      children: [
                                        LoadURL(context),
                                        const SizedBox(width: 12),
                                        CreatePDF(context),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LoadURL(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/icons/hyperlink.png',
              width: 350,
              height: 60,
            ),
            Text(
              'Load URL',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget CreatePDF(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/icons/createPDF.png',
              width: 350,
              height: 60,
            ),
            Text(
              'Create PDF',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

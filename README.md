# Flutter App for scanning and saving documents

# Login screen

![image](https://github.com/user-attachments/assets/697741c6-b734-464a-976b-9c4d79df5954)

# Register screen
On registration, the user recieves a 6-digit code on their email, which they have to enter into the application to activate their account, if they do not, and later decide to create an account again, a new 6-digit code is sent to their email.

![image](https://github.com/user-attachments/assets/5eb4441c-5e1b-4497-af15-b2dc3d9f725d)

![image](https://github.com/user-attachments/assets/a02c2759-d33f-4c2c-9f3e-c4cf6728813d)

# Forgot Password screen

![image](https://github.com/user-attachments/assets/833f095a-fd3c-44bb-b769-66bdc107e70a)

# Main/Document screen

After the user succesfully logs in, they are redirected to the Document screen, which is initially empty.

![image](https://github.com/user-attachments/assets/7d494a20-f139-456a-8461-227f1e6cc5c8)

On the Document screens app bar, there is a "plus" icon, which when tapped a dialog opens where the user can enter the documents name, and choose from a list of suggested document types, what kind of document it is. In further development, the user will be able to create a document type. The screen also has a bottom navigation bar, which helps the user navigate between the two main screens, Document and Account screen.

![image](https://github.com/user-attachments/assets/9f345936-3dc8-445f-b06e-c71768e63bca)


# Files screen

The files screen is accessed after tapping on a document. Here are stored the files for that document, which can be either a PDF (an image sharpened and turned into black and white), or an OCR file (text extracted from an image).

![image](https://github.com/user-attachments/assets/8bb28f62-5ebd-414b-9982-a240522075a3)

Like the Document screen, in the app bar there is a plus icon, which when tapped a dialog is opened, from which the user can choose to create either a PDF file, or an OCR file.

![image](https://github.com/user-attachments/assets/cfe2ebb7-eb6a-4477-b1eb-7340420d3bb0)

The user can select multiple files by holding down on the file, and then delete them at the same time (the same is available for the Document screen, and if the user chooses to delete a document, its contents are also deleted).

![image](https://github.com/user-attachments/assets/884a966b-4eb7-40fa-8344-96a000e12778)

# Image to OCR/PDF screen

This screen is the same for both types, there's a flag which indicates whether it's an OCR or not, and based on that it's decided which method is called, and the name for the app bar. Here the user can choose to either take images with their phone camera, or choose an already available image from their gallery.

![image](https://github.com/user-attachments/assets/48c46bf3-e118-4c2f-9966-cd7fd850d839)

If the user chooses to abandon their work, a confirmation dialog is displayed.

![image](https://github.com/user-attachments/assets/eb0f9ebe-5665-4f2e-b49f-94b081e1c901)

# File View screen

In this screen the user can view the file. They can also change the files name, share it, download it (though it downloads to /storage/emulated/0/android/data/com.example.file_upload_app_part2/FileUploadApp) and delete it.

![image](https://github.com/user-attachments/assets/860efe9b-ef4b-47b8-854e-ab71ee3cf5a3)
![image](https://github.com/user-attachments/assets/3b94d1b1-f3ab-4f3c-bf26-a487c3df9b0d)
![image](https://github.com/user-attachments/assets/c40274c8-3883-4ac6-8a40-ebaa4512036b)

# Account screen

The user can Delete/Deactivate their account, and here the log out button is located.

![image](https://github.com/user-attachments/assets/b2eebfd1-255d-4c35-9a4f-f7f8a18c74c0)








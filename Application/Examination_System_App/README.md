# Flet LMS Desktop Application

## Features
- Modular pages: Login, Student, Instructor, Admin, Exam
- Role-based routing after login
- API client for backend communication
- Modern UI with Flet components

## Setup
1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Run the app:
   ```bash
   python main.py
   ```

## Packaging as Desktop App
- Use [PyInstaller](https://pyinstaller.org/) to package as an executable:
   ```bash
   pip install pyinstaller
   pyinstaller --noconfirm --onefile --windowed main.py
   ```
- The executable will be in the `dist` folder.

## Notes
- Update the API base URL in `services/api_client.py` as needed.
- Each page is in the `/pages` folder for modularity. 
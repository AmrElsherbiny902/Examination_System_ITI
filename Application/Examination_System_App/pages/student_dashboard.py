import flet as ft

class StudentDashboard(ft.View):
    def __init__(self, page: ft.Page):
        super().__init__(route="/student")
        self.page = page

        # Sample exams data (replace with real API response)
        exams = [
            {"title": "Math Final", "subject": "Mathematics", "date": "2025-06-25 10:00 AM"},
            {"title": "Physics Quiz", "subject": "Physics", "date": "2025-06-27 02:00 PM"},
        ]

        # Header with Welcome + Logout
        header = ft.Row(
            controls=[
                ft.Text("🎓 Welcome, Student!", theme_style="headlineMedium", expand=True),
                ft.ElevatedButton("Logout", on_click=self.logout, bgcolor="red", color="white"),
            ],
            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
        )

        # Exam Cards
        exam_cards = []
        for exam in exams:
            exam_cards.append(
                ft.Card(
                    content=ft.Container(
                        content=ft.Column([
                            ft.Text(exam["title"], size=20, weight="bold"),
                            ft.Text(f"Subject: {exam['subject']}"),
                            ft.Text(f"Date: {exam['date']}"),
                            ft.ElevatedButton("Start Exam", on_click=lambda e, t=exam["title"]: self.start_exam(t)),
                        ]),
                        padding=20
                    ),
                    width=400
                )
            )

        # Layout Column
        layout = ft.Column(
            controls=[
                header,
                ft.Divider(),
                ft.Text("📚 Available Exams", size=18, weight="bold"),
                ft.GridView(
                        runs_count=2,
                        max_extent=500,
                        child_aspect_ratio=2,
                        spacing=20,
                        run_spacing=20,
                        controls=exam_cards,
                        expand=True
                    )
            ],
            scroll=ft.ScrollMode.AUTO,
        )

        # Main Page Layout
        self.controls = [
            ft.Container(
                content=layout,
                padding=20,
                expand=True
            )
        ]

    def start_exam(self, _): #title
        # Go to the exam page (pass exam info via client_storage if needed)
        self.page.go("/exam")

    def logout(self, _):
        # Clear session and go back to login
        self.page.client_storage.clear()
        self.page.go("/")

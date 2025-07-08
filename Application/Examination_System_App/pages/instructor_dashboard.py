import flet as ft
from flet import Icons  # ✅ Import Icons with capital "I"
from datetime import datetime

class InstructorDashboard(ft.View):
    """
    This is the instructor dashboard page.
    It allows the instructor to create exams and view student results.
    """

    def __init__(self, page: ft.Page):
        super().__init__(route="/instructor")
        self.page = page

        # Simulated instructor data
        self.courses = [
            {"code": "PY101", "name": "Python Basics"},
            {"code": "JS201", "name": "JavaScript Essentials"}
        ]

        self.exams = []
        self.results = []
        self.exam_id_counter = 1

        # UI inputs
        self.course_dropdown = ft.Dropdown(
            label="Select Course",
            options=[ft.dropdown.Option(c["code"]) for c in self.courses],
            on_change=self.load_exams,
            width=200
        )

        self.exam_type = ft.Dropdown(
            label="Exam Type",
            options=[
                ft.dropdown.Option("Midterm"),
                ft.dropdown.Option("Final"),
                ft.dropdown.Option("Quiz")
            ]
        )
        self.total_marks = ft.TextField(label="Total Marks", width=120)
        self.passing_score = ft.TextField(label="Passing Score", width=150)
        self.schedule_date = ft.TextField(label="Date (YYYY-MM-DD)", width=200)

        self.exam_list_column = ft.Column()
        self.result_list_column = ft.Column()

        # 🔘 Logout Button
        self.logout_button = ft.ElevatedButton(
            text="Logout",
            icon=Icons.LOGOUT,       # ✅ Correct usage of Icons
            on_click=self.logout,
            bgcolor="#EF5350",       # HEX for RED_400
            color="white"
        )

        self.controls = [
            ft.Row([
                ft.Text("Instructor Dashboard", theme_style="headlineMedium", expand=1),
                self.logout_button
            ]),
            ft.Divider(),

            ft.Text("📚 Your Courses", theme_style="titleMedium"),
            self.course_dropdown,

            ft.Divider(),

            ft.Text("📝 Create Exam", theme_style="titleMedium"),
            ft.Row([self.exam_type, self.total_marks, self.passing_score, self.schedule_date]),
            ft.ElevatedButton("Add Exam", on_click=self.add_exam),

            ft.Divider(),

            ft.Text("📄 Exams in Selected Course", theme_style="titleMedium"),
            self.exam_list_column,

            ft.Divider(),

            ft.Text("🎓 Student Results", theme_style="titleMedium"),
            self.result_list_column
        ]

    def logout(self, e):
        """Handle logout and redirect to login page."""
        self.page.go("/")

    def load_exams(self, _=None):
        selected = self.course_dropdown.value
        if not selected:
            return
        self.exam_list_column.controls.clear()
        for exam in self.exams:
            if exam["course_code"] == selected:
                self.exam_list_column.controls.append(
                    ft.Row([
                        ft.Text(f"{exam['type']} - {exam['date']} - {exam['total']} marks"),
                        ft.ElevatedButton("Show Results", on_click=lambda e, ex=exam: self.load_results(ex))
                    ])
                )
        self.page.update()

    def load_results(self, exam):
        self.result_list_column.controls.clear()
        for r in self.results:
            if r["exam_id"] == exam["exam_id"]:
                self.result_list_column.controls.append(
                    ft.Text(f"{r['student']} scored {r['score']} / {exam['total']}")
                )
        if not self.result_list_column.controls:
            self.result_list_column.controls.append(ft.Text("No results yet."))
        self.page.update()

    def add_exam(self, _):
        if not all([
            self.course_dropdown.value,
            self.exam_type.value,
            self.total_marks.value,
            self.passing_score.value,
            self.schedule_date.value
        ]):
            self.page.snack_bar = ft.SnackBar(ft.Text("⚠️ Fill all fields"))
            self.page.snack_bar.open = True
            self.page.update()
            return

        try:
            datetime.strptime(self.schedule_date.value, "%Y-%m-%d")
        except ValueError:
            self.page.snack_bar = ft.SnackBar(ft.Text("Invalid date format (use YYYY-MM-DD)"))
            self.page.snack_bar.open = True
            self.page.update()
            return

        exam = {
            "exam_id": self.exam_id_counter,
            "course_code": self.course_dropdown.value,
            "type": self.exam_type.value,
            "total": int(self.total_marks.value),
            "passing": int(self.passing_score.value),
            "date": self.schedule_date.value
        }
        self.exam_id_counter += 1
        self.exams.append(exam)

        self.results.extend([
            {"exam_id": exam["exam_id"], "student": "Ahmed Farouk", "score": 85},
            {"exam_id": exam["exam_id"], "student": "Laila Ehab", "score": 72}
        ])

        self.exam_type.value = None
        self.total_marks.value = ""
        self.passing_score.value = ""
        self.schedule_date.value = ""
        self.load_exams()

        self.page.snack_bar = ft.SnackBar(ft.Text("✅ Exam added"))
        self.page.snack_bar.open = True
        self.page.update()

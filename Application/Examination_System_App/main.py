import flet as ft
from pages.login_page import LoginPage
from pages.student_dashboard import StudentDashboard
from pages.instructor_dashboard import InstructorDashboard
from pages.admin_dashboard import AdminDashboard
from pages.exam_page import ExamPage
from pages.exam_submitted_page import ExamSubmittedPage

PAGES = {
    "/": LoginPage,
    "/student": StudentDashboard,
    "/instructor": InstructorDashboard,
    "/admin": AdminDashboard,
    "/exam": ExamPage,
    "/exam_submitted": ExamSubmittedPage,
}

def main(page: ft.Page):
    page.title = "Learning Management System"
    page.window_width = 1024
    page.window_height = 768
    page.window_resizable = True
    page.window_icon = "Assets/iti.png"

    def route_change(_):
        page.views.clear()
        view_cls = PAGES.get(page.route, PAGES["/"])
        view = view_cls(page)
        page.views.append(view)
        page.update()

    def view_pop(_):
        page.views.pop()
        top_view = page.views[-1]
        page.go(top_view.route)

    page.on_route_change = route_change
    page.on_view_pop = view_pop

    # Make sure route change works on initial launch
    page.go(page.route or "/")

if __name__ == "__main__":
    ft.app(target=main)

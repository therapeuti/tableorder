from django.core.management.base import BaseCommand
from menus.models import Menu

class Command(BaseCommand):
    help = '메뉴 초기 데이터를 설정합니다'

    def handle(self, *args, **options):
        self.stdout.write('메뉴 설정 시작...')

        menus_data = [
            {'name': '해물칼국수', 'price': 10000, 'description': '신선한 해물이 들어간 칼국수'},
            {'name': '비빔칼국수', 'price': 8000, 'description': '매콤달콤한 비빔칼국수'},
            {'name': '공기밥', 'price': 1000, 'description': '갓 지은 따뜻한 밥'},
            {'name': '도토리묵', 'price': 8000, 'description': '쪽깃한 도토리묵'},
            {'name': '편육', 'price': 12000, 'description': '부드러운 수육'},
            {'name': '김치', 'price': 3000, 'description': '집에서 담근 김치'},
            {'name': '계란말이', 'price': 6000, 'description': '부드러운 계란말이'},
            {'name': '파전', 'price': 9000, 'description': '바삭한 파전'},
        ]

        created_count = 0
        existing_count = 0

        for menu_data in menus_data:
            menu, created = Menu.objects.get_or_create(
                name=menu_data['name'],
                defaults={
                    'price': menu_data['price'],
                    'description': menu_data['description'],
                    'is_active': True
                }
            )

            if created:
                created_count += 1
                self.stdout.write(
                    self.style.SUCCESS(f'✓ 메뉴 "{menu.name}" 생성됨 ({menu.price:,}원)')
                )
            else:
                existing_count += 1
                self.stdout.write(f'- 메뉴 "{menu.name}" 이미 존재')

        total_menus = Menu.objects.count()

        self.stdout.write('\n' + '='*50)
        self.stdout.write(f'📊 결과:')
        self.stdout.write(f'   새로 생성: {created_count}개')
        self.stdout.write(f'   기존 메뉴: {existing_count}개')
        self.stdout.write(f'   총 메뉴: {total_menus}개')
        self.stdout.write(self.style.SUCCESS('\n🎉 메뉴 설정 완료!'))
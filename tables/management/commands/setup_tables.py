from django.core.management.base import BaseCommand
from tables.models import Table

class Command(BaseCommand):
    help = '테이블 초기 데이터를 설정합니다 (1-20번 테이블)'

    def add_arguments(self, parser):
        parser.add_argument(
            '--count',
            type=int,
            default=20,
            help='생성할 테이블 개수 (기본값: 20)'
        )
        parser.add_argument(
            '--seats',
            type=int,
            default=4,
            help='테이블당 좌석 수 (기본값: 4)'
        )

    def handle(self, *args, **options):
        table_count = options['count']
        seats_per_table = options['seats']

        self.stdout.write(f'테이블 설정 시작... (1-{table_count}번)')

        created_count = 0
        existing_count = 0

        for i in range(1, table_count + 1):
            table, created = Table.objects.get_or_create(
                number=i,
                defaults={
                    'seats': seats_per_table,
                    'status': 'empty'
                }
            )

            if created:
                created_count += 1
                self.stdout.write(
                    self.style.SUCCESS(f'✓ 테이블 {i}번 생성됨')
                )
            else:
                existing_count += 1
                self.stdout.write(f'- 테이블 {i}번 이미 존재')

        total_tables = Table.objects.count()

        self.stdout.write('\n' + '='*50)
        self.stdout.write(f'📊 결과:')
        self.stdout.write(f'   새로 생성: {created_count}개')
        self.stdout.write(f'   기존 테이블: {existing_count}개')
        self.stdout.write(f'   총 테이블: {total_tables}개')
        self.stdout.write(self.style.SUCCESS('\n🎉 테이블 설정 완료!'))
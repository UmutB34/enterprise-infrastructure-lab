.PHONY: test lint

test:
	bash examples/backup/restore-test.sh

lint:
	bash -n examples/backup/restore-test.sh
	bash -n examples/docs-sync/pull-docs.sh
	python3 -c "import yaml,sys; yaml.safe_load(open('examples/ansible/baseline.yml'))"

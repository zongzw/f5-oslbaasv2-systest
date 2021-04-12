# TODO: run all tests in parallel to save time.
from ansible.cli.playbook import PlaybookCLI as pbc

ipath = r"/Users/shjin/Desktop/mytest/ansbgthub/f5-oslbaasv2-systest/conf.d/group_and_hosts-dev"
testpath = r"/Users/shjin/Desktop/mytest/ansbgthub/f5-oslbaasv2-systest/testcases"
def main():
    
    cli = pbc(["","-i",ipath,testpath+r"/dev_test.yml"])
    exitcode = cli.run()

if(__name__ == "__main__"):
    main()